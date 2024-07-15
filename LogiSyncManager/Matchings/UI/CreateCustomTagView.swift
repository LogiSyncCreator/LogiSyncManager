//
//  CreateCustomTagView.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct CreateCustomTagView: View {
    
    @EnvironmentObject var environVM: EnvironViewModel
    
    @Environment(\.colorScheme) var colorScheme
    @State var isOpend: Bool = false
    @State var rotate: Double = 0.0
    
    @State var reView: Bool = false
    
    @State var key: String = "新規でステータスを作成"
    
    @State var icon: String = ""
    @State var colorSelector: String = "gray"
    @State var statusName: String = ""
    
    @State var previewIconName: [String] = []
    
    @State var shipperId: String
    @State var status: [CustomStatus]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
                    HStack{
                        Button {
                            withAnimation(){
                                isOpend.toggle()
                                if isOpend {
                                    rotate = 180.0
                                } else {
                                    rotate = 0.0
                                }
                            }
                        } label: {
                            HStack{
                                Text(key).font(.title).foregroundStyle(Color(.label)).padding(.bottom)
                                Spacer()
                                Image(systemName: "chevron.up").rotationEffect(Angle(degrees: rotate)).padding(.bottom)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                    Divider().padding(.bottom)
                    if isOpend {
                        VStack(alignment: .leading,spacing: 0){
                            //  内容を書き込む
//                            {
//                                "icon": "car.circle",
//                                "shipper": "shipper",
//                                "manager": "manager",
//                                "color": "red",
//                                "delete": false,
//                                "name": "運転中",
//                                "index": 1
//                              }
                            Text("プレビュー")
                            HStack{
                                StatusIcon(width: 50, symbole: icon, symboleColor: colorSelector)
                                Text(statusName.isEmpty ? "ステータス名" : statusName).font(.system(size: 50))
                                
                            }.frame(height: 100)
                            TextField("SF Symbolesを入力", text: $icon).padding(.vertical)
                            Divider()
                            HStack{
                                Text("カラー選択")
                                Picker("カラー選択", selection: $colorSelector) {
                                    Text("グレー").tag("gray")
                                    Text("グリーン").tag("green")
                                    Text("イエロー").tag("yellow")
                                    Text("レッド").tag("red")
                                }
                                Spacer()
                            }.padding(.vertical)
                            
                            Divider()
                            
                            TextField("ステータス名", text: $statusName).padding(.vertical)
                            
                            Divider()

                            HStack{
                                Spacer()
                                Button("作成") {
                                    // 作成処理
                                    Task {
                                        do {
                                            try await environVM.setCustomStatus(icon: icon,shipper: shipperId, color: colorSelector, name: statusName, index: status.count + 1)
                                        } catch {
                                            print("API ERR: カスタムステータスの送信")
                                        }
                                    }
                                    
                                    
                                }.buttonStyle(BorderedProminentButtonStyle()).disabled(icon.isEmpty || statusName.isEmpty)
                                Spacer()
                            }.padding()
                            
                        }.background(Color(colorScheme == .light ? .secondarySystemBackground : .systemBackground))
                            .padding()
                    }
                }
    }
    
}

//#Preview {
//    CreateCustomTagView()
//}
