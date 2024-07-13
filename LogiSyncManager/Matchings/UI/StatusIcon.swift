//
//  StatusIcon.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct StatusIcon: View {
    
    var width: CGFloat
    var symbole: String
    var symboleColor: String
    
    var body: some View {
        ZStack{
        Circle().frame(width: width).foregroundStyle(Color(.systemBackground))
        Image(systemName: symbole.isEmpty ? "xmark.circle" : symbole).font(.system(size: width - 5)).foregroundColor(Color(symboleColor.isEmpty ? "gray" : symboleColor)).onChange(of: symboleColor) {
            print(symbole)
        }
    }
    }
}
