//
//  MatchingSheet.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct MatchingSheet: View {
    
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
                    
                    CreateCustomTagView().padding()
                
                Text("ステータス一覧").padding(.horizontal)
                
                
                List {
                    StatusLabel(width: 30, symbole: "checkmark.circle.fill", color: "green", label: "オンライン")
                    StatusLabel(width: 30, symbole: "xmark.circle", color: "gray", label: "オフライン")
                    //                    StatusLabel(width: 30, symbole: "house.circle", color: "yellow", label: "待機中")
                    //                    StatusLabel(width: 30, symbole: "car.circle", color: "red", label: "運転中")
                    ForEach(matching.status, id: \.id) { data in
                        StatusLabel(width: 30, symbole: data.icon, color: data.color, label: data.name)
                    }
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
                // 削除処理
                withAnimation {
                    isDelete.toggle()
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
