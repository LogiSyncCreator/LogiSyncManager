//
//  UserThumbnalil.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct UserThumbnalil: View {
    
    var role: String
    var width: CGFloat
    
    var body: some View {
        ZStack{
            Circle().frame(width: width).foregroundStyle(.blue).overlay {
                Image(systemName: role == "運転手" ? "truck.box" : "person.circle.fill")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: role == "運転手" ? (width - 30) : (width - 5))
                .foregroundStyle(Color("UnRapLabelColor"))
                .scaleEffect(x: role == "運転手" ? -1 : 1, y: 1)
            }
        }
    }
}


