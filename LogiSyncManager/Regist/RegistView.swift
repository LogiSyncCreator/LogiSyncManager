//
//  Regist.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct RegistView: View {
    
    @State var shipperId: String = ""
    @State var driverId: String = ""
    @State var address: String = ""
    
    @State var isAlert: Bool = false
    @State var isErr: Bool = false
    @State var errText: String = "マッチングに失敗しました"
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text("荷主のユーザーID").font(.title).bold()
            TextField("荷主のユーザーID", text: $shipperId)
            Divider()
            Text("運転手のユーザーID").font(.title).bold()
            TextField("運転手のユーザーID", text: $driverId)
            Divider()
            Text("運び先住所").font(.title).bold()
            TextField("運び先住所", text: $address)
            Divider()
            
            if isErr {
                Text(errText)
            }
            
            HStack{
                Spacer()
                Button(action: {
                    // 登録処理
                    isAlert.toggle()
                }, label: {
                    Text("作成")
                }).buttonStyle(BorderedProminentButtonStyle()).disabled(isAlert || shipperId.isEmpty || driverId.isEmpty || address.isEmpty)
                Spacer()
            }.padding()
                .alert("完了", isPresented: $isAlert) {
                    Button("OK") {
                        // 処理
                    }
                } message: {
                    Text("マッチングの作成が完了しました")
                }
            
        }).padding().frame(width: 800, height: 500).background(Material.ultraThickMaterial, in: RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
    }
}

#Preview {
    RegistView()
}
