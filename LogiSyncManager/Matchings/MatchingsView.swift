//
//  MatchingsView.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

struct MatchingsView: View {
        let cards = [
            ("荷主 太郎", "株式会社にぬし", "荷主"),
            ("荷主 次郎", "株式会社にぬし", "荷主"),
            ("荷主 三郎", "株式会社にぬし", "荷主"),
            ("荷主 四郎", "株式会社にぬし", "荷主"),
            ("荷主 五郎", "株式会社にぬし", "荷主")
        ]
        
        var body: some View {
            GeometryReader { geo in
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(cards, id: \.0) { card in
                            Card(userName: card.0, company: card.1, role: card.2, width: 100, geo: geo)
                                .padding()
                        }
                    }
                    .padding()
                }
            }
        }
    }

#Preview {
    MatchingsView()
}

