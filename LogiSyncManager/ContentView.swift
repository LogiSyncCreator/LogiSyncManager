//
//  ContentView.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/09.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State var index: Int = 0
    
    @State var isViewSideBar: Bool = false

    var body: some View {
        ZStack{
            
            switch(index){
            case 0:
                LoginView(index: $index).onAppear(){
                    isViewSideBar = false
                }
            case 1:
                MatchingsView().padding(.top).onAppear(){
                    isViewSideBar = true
                }
            case 2:
                Text("2").onAppear(){
                    isViewSideBar = true
                }
            case 3:
                Text("3").onAppear(){
                    isViewSideBar = true
                }
            case 4:
                LoginView(index: $index).onAppear(){
                    isViewSideBar = false
                }
            default:
                LoginView(index: $index).onAppear(){
                    isViewSideBar = false
                }
            }
            
            if isViewSideBar {
                SideBarView(index: $index)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
