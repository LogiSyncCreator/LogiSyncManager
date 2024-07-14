//
//  MatchingPagenation.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/14.
//

import SwiftUI

struct MatchingPagenation: View {
    
    @State var matchings: [ManagedMatching]
    @State var geo: GeometryProxy
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 50) {
            ForEach(matchings, id: \.self){ matching in
                Card(matching: matching, width: 100, geo: geo)
            }
        }
    }
}
