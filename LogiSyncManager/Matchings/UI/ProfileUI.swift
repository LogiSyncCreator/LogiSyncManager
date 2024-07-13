//
//  ProfileUI.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct ProfileUI: View {
    var profile: String
    @State private var isOpen: Bool = true
    @State private var textHeight: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading) {
            Text(isOpen ? profile : String(profile.prefix(10)) + "...")
                .lineLimit(nil).padding(.horizontal)
            
            HStack{
                Spacer()
                if profile.count > 10 {
                    Button(action: {
                        withAnimation {
                            isOpen.toggle()
                        }
                    }) {
                        Text(isOpen ? "折りたたむ" : "続きを読む")
                            .foregroundColor(.blue)
                    }.onAppear(){
                        isOpen.toggle()
                    }
                }
            }.padding(.trailing)

            Divider()
        }
    }
}

#Preview {
    ProfileUI(profile: "testtesttes\ntesttestt")
}
