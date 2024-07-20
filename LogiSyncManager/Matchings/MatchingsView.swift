//
//  MatchingsView.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/11.
//

import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        var elements: [Element] = []
        
        for (index, element) in self.enumerated() {
            elements.append(element)
            if elements.count == size || index == self.count - 1 {
                chunks.append(elements)
                elements = []
            }
        }
        
        return chunks
    }
}

struct MatchingsView: View {
    
    @EnvironmentObject var environVM: EnvironViewModel
    
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(environVM.model.matchings.chunked(into: 6), id: \.self) { chunk in
                        VStack{
                            Spacer()
                            MatchingPagenation(matchings: chunk, geo: geo).frame(width: geo.size.width)
                            Spacer()
                        }
                    }
                }.scrollTargetLayout()
            }.scrollTargetBehavior(.paging)
                .onAppear(){
                    environVM.receivedMatching.send()
                }
        }
    }
}

#Preview {
    MatchingsView().environmentObject(EnvironViewModel())
}

