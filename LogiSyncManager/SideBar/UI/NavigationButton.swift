//
//  NavigationButton.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct NavigationButton: View {
    
    let iconName: String
    let title: String
    let pageIndex: Int
    
    @Binding var index: Int
    
    var body: some View {
        Button {
            withAnimation {
                index = pageIndex
            }
        } label: {
            HStack{
                Image(systemName: iconName).bold().font(.title2)
                Text(title).textCase(.uppercase).bold().font(.title2)
            }.foregroundStyle(Color(.label))
        }
    }
}

#Preview {
    ContentView()
}
