//
//  MatchingsView.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct MatchingsView: View {
    var body: some View {
        GeometryReader {geo in
            VStack{
                Card(userName: "荷主 太郎", company: "株式会社にぬし", role: "荷主", width: 100, geo: geo).padding()
            }
        }
    }
}

#Preview {
    MatchingsView()
}
