//
//  MatchingSheet.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

extension Array {
    subscript (element index: Index) -> Element? {
        //　MARK: 配列の要素以上を指定していたらnilを返すようにする
        indices.contains(index) ? self[index] : nil
    }
}

struct MatchingSheet: View {
    @EnvironmentObject var environVM: EnvironViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State var matching: ManagedMatching
    
    @Binding var isDelete: Bool
    @State var isDeleteAlert: Bool = false
    
    @State var userName: String = "株式会社にぬし"
    @State var company: String = "荷主 太郎"
    @State var role: String = "荷主"
    @State var width: CGFloat = 100
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                HStack{
                    Group{
                        UserThumbnalil(role: matching.user.shipper.role, width: width)
                        Spacer().frame(width: 30)
                        VStack(alignment: .leading){
                            Text(matching.user.shipper.name)
                            Text(matching.user.shipper.company)
                            Text("納期：\(transferDateString(dateString: matching.matching.start))")
                        }
                    }
                    Divider()
                    Group{
                        UserThumbnalil(role: matching.user.driver.role, width: width)
                        Spacer().frame(width: 30)
                        VStack(alignment: .leading){
                            Text(matching.user.driver.name)
                            Text(matching.user.driver.company)
                        }
                    }
                }.padding().frame(height: 200)
                Divider().padding(.horizontal)
                
                CreateCustomTagView(shipperId: matching.user.shipper.userId, status: matching.status).padding()
                
                HStack {
                    Text("ステータス一覧")
                    Spacer()
                    Button("対応ユーザのステータスの更新"){
                        Task{
                            try await environVM.sendCreateStatusNotification(shipper: matching.user.shipper.userId)
                        }
                    }
                }.padding(.horizontal)
                
                
                List {
                    StatusLabel(width: 30, symbole: "checkmark.circle.fill", color: "green", label: "オンライン")
                    StatusLabel(width: 30, symbole: "xmark.circle", color: "gray", label: "オフライン")
                    ForEach(environVM.model.matchings[matching.index].status, id: \.self) { data in
                        if !data.delete {
                            StatusLabel(width: 30, symbole: data.icon, color: data.color, label: data.name)
                        }
                    }.onDelete(perform: { indexSet in
                        
                        indexSet.forEach { index in
                            
                            guard environVM.model.matchings.indices.contains(matching.index),
                                  environVM.model.matchings[matching.index].status.indices.contains(index) else {
                                // インデックスが無効の場合はスキップ
                                return
                            }
                            
                            let statusId = environVM.model.matchings[matching.index].status[index].id
                            Task{
                                try await environVM.deleteStatus(uuid: statusId)
                                
                                await MainActor.run{
                                    if environVM.model.matchings.indices.contains(matching.index),
                                       environVM.model.matchings[matching.index].status.indices.contains(index) {
                                        environVM.model.matchings[matching.index].status[index].delete = true
                                    }
                                }
                            }
                        }
                    })
                }
                
                Spacer()
            }
            VStack {
                HStack{
                    Spacer()
                    Button(action: {
                        isDeleteAlert.toggle()
                    }, label: {
                        Image(systemName: "trash").foregroundStyle(.red)
                    })
                }
                Spacer()
            }.padding()
        }.alert("警告", isPresented: $isDeleteAlert) {
            Button("OK", role: .destructive) {
                Task{
                    // 削除処理
                    try await environVM.deleteMatching(uuid: environVM.model.matchings[matching.index].matching.id)
                    await MainActor.run {
                        withAnimation {
                            isDelete.toggle()
                        }
                    }
                }
            }
            Button("Cancel", role: .cancel) {
            }
        } message: {
            Text("本当にマッチングを削除してもよろしいですか？")
        }
        .background(Color(colorScheme == .light ? .secondarySystemBackground : .systemBackground))
    }
    
    func transferDateString(dateString: String) -> String {
        
        // DateFormatterを使用してISO 8601形式の文字列をDate型に変換
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        if let date = formatter.date(from: dateString) {
            // 出力のカスタム形式のDateFormatterを作成
            let customFormatter = DateFormatter()
            customFormatter.dateFormat = "yy-MM-dd HH:mm"
            
            // Date型をカスタム形式の文字列に変換
            let formattedDateString = customFormatter.string(from: date)
            return formattedDateString // 出力: "24-06-27 17:30"
        } else {
            return ""
        }
    }
}

struct StatusLabel: View {
    
    let width: CGFloat
    let symbole: String
    let color: String
    let label: String
    
    var body: some View {
        HStack(){
            StatusIcon(width: width, symbole: symbole, symboleColor: color)
            Text(label)
        }
    }
}

#Preview {
    ContentView().environmentObject(EnvironViewModel())
}
