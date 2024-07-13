//
//  MatchingSheet.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct MatchingSheet: View {
    
    @Environment(\.colorScheme) var colorScheme
    
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
                        UserThumbnalil(role: role, width: width)
                        Spacer().frame(width: 30)
                        VStack(alignment: .leading){
                            Text(userName)
                            Text(company)
                            Text("納期：24-08-07 12:00")
                        }
                    }
                }.padding()
                Divider().padding(.horizontal)
                
                ProfileUI(profile: "初めまして荷主 太郎です")
                
                CreateCustomTagView().padding()
                
                Text("ステータス一覧").padding(.horizontal)
                
                List {
                    StatusLabel(width: 30, symbole: "checkmark.circle.fill", color: "green", label: "オンライン")
                    StatusLabel(width: 30, symbole: "xmark.circle", color: "gray", label: "オフライン")
                    StatusLabel(width: 30, symbole: "house.circle", color: "yellow", label: "待機中")
                    StatusLabel(width: 30, symbole: "car.circle", color: "red", label: "運転中")
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
    MatchingsView()
}
