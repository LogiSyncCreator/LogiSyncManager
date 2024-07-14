//
//  Regist.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct RegistView: View {
    
    @EnvironmentObject var environVM: EnvironViewModel
    
    @State var shipperId: String = ""
    @State var driverId: String = ""
    @State var address: String = ""
    
    @State var isAlert: Bool = false
    @State var isErr: Bool = false
    @State var errText: String = "マッチングに失敗しました"
    @State var date: Date = Date()
    
    var body: some View {
        ZStack {
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
                Text("納期").font(.title).bold()
                DatePicker(
                        "",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                .datePickerStyle(.compact).frame(width: 200)
                Divider()
                
                if isErr {
                    Text(errText)
                }
                
                HStack{
                    Spacer()
                    Button(action: {
                        // 登録処理
                        environVM.sendMatching.send(SendMatchingInformation(manager: environVM.model.account.user.userId, shipper: shipperId, driver: driverId, address: address, start: date))
                        isAlert.toggle()
                    }, label: {
                        Text("作成")
                    }).buttonStyle(BorderedProminentButtonStyle()).disabled(isAlert || shipperId.isEmpty || driverId.isEmpty || address.isEmpty)
                    Spacer()
                }.padding()
                    .alert("完了", isPresented: $environVM.matchingsAlert) {
                        Button("OK") {
                            // 処理
                            isAlert = false
                        }
                    } message: {
                        Text("マッチングの作成が完了しました")
                    }
                
            }).padding().frame(width: 800, height: 500).background(Material.ultraThickMaterial, in: RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
            
            if environVM.isInsertMatchings {
                VStack{
                    ProgressView()
                    Text("作成中").padding(.top).font(.title).bold()
                }.frame(width: 300, height: 300).background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 50))
            }
        }
    }
}

#Preview {
    RegistView().environmentObject(EnvironViewModel())
}
