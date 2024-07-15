//
//  Card.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct Card: View {
    
    @State var matching: ManagedMatching
    
    @State var isOpenSheet: Bool = false
    @State var isDelete: Bool = false
    
    @State var width: CGFloat
    @State var geo: GeometryProxy
    
    var body: some View {
        if !isDelete {
            VStack(alignment: .leading){
                HStack{
                    UserThumbnalil(role: matching.user.shipper.role, width: width)
                    Spacer().frame(width: 30)
                    VStack(alignment: .leading){
                        Text(matching.user.shipper.name)
                        Text(matching.user.shipper.company)
                        Text(transferDateString(dateString: matching.matching.start))
                    }
                }.padding()
                Divider().opacity(0)
            }.frame(width: geo.size.width / 2 * 0.7).background(Material.ultraThickMaterial , in: RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))).shadow(radius: 2)
                .onTapGesture {
                    isOpenSheet.toggle()
                }.sheet(isPresented: $isOpenSheet, content: {
                    MatchingSheet(matching: matching, isDelete: $isDelete)
                })
        }
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

#Preview {
    MatchingsView()
}
