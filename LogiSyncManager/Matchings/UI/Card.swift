//
//  Card.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct Card: View {
    
    @State var isOpenSheet: Bool = false
    @State var isDelete: Bool = false
    
    var userName: String
    var company: String
    var role: String
    var width: CGFloat
    @State var geo: GeometryProxy
    var body: some View {
        if !isDelete {
            VStack(alignment: .leading){
                HStack{
                    UserThumbnalil(role: role, width: width)
                    Spacer().frame(width: 30)
                    VStack(alignment: .leading){
                        Text(userName)
                        Text(company)
                        Text("納期：24-08-07 12:00")
                    }
                }.padding()
                Divider().opacity(0)
            }.frame(width: geo.size.width / 2 * 0.7).background(Material.ultraThickMaterial , in: RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))).shadow(radius: 2)
                .onTapGesture {
                    isOpenSheet.toggle()
                }.sheet(isPresented: $isOpenSheet, content: {
                    MatchingSheet(isDelete: $isDelete)
                })
        }
    }
}

#Preview {
    MatchingsView()
}
