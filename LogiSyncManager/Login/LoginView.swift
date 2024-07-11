//
//  LoginView.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var index: Int
    
    @State var userId: String = ""
    @State var userPass: String = ""
    
    var body: some View {
        Rectangle().ignoresSafeArea().overlay {
        VStack(alignment: .center){
            Text("logisync").textCase(.uppercase).font(.system(size: 80)).bold().foregroundColor(Color(.label))
            Group{
                TextField("USERID", text: $userId).font(.title).foregroundColor(Color(.label))
                Divider()
                SecureField("PASSWORD", text: $userPass).font(.title).foregroundColor(Color(.label))
                Divider()
            }.frame(width: 700)
            HStack(content: {
                Button(action: {
                    
                }, label: {
                    Text("新規登録").foregroundStyle(.white).font(.title).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)).bold()
                }).background(.blue, in: RoundedRectangle(cornerRadius: 5)).padding(.trailing)
                Button(action: {
                    // ログイン処理
                    
                    withAnimation {
                        index = 1
                    }
                    
                    
                }, label: {
                    Text("ログイン").foregroundStyle(.white).font(.title).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)).bold()
                }).background(.blue, in: RoundedRectangle(cornerRadius: 5)).padding(.leading)
            }).padding()
        }.padding()
    }.foregroundStyle(.background)
    }
}

#Preview {
    ContentView()
}
