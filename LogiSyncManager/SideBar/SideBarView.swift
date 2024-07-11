//
//  SideBarView.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/09.
//

import SwiftUI

struct SideBarView: View {
    
    @State var isOpen: Bool = true
    @State var xOffset: CGFloat = .zero
    @Binding var index: Int
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack{
                Group{
                    Rectangle().frame(width: geometry.size.width * 0.2).ignoresSafeArea().foregroundStyle(Material.ultraThin).overlay {
                        VStack{
                            HStack{
                                Button(action: {
                                    if !isOpen {
                                        withAnimation {
                                            xOffset = 0 - geometry.size.width * 0.2
                                            isOpen.toggle()
                                        }
                                    } else {
                                        
                                    }
                                }, label: {
                                    Image(systemName: "sidebar.leading").foregroundStyle(isOpen ? .clear : .blue)
                                })
                                Spacer()
                            }.padding([.leading, .bottom])
                            Text("logisync").textCase(.uppercase).bold().font(.title).padding(.bottom, 50)
                            VStack(alignment: .leading){
                                Divider()
                                NavigationButton(iconName: "person.2", title: "matching", pageIndex: 1, index: $index).padding()
                                Divider()
                                NavigationButton(iconName: "person.2", title: "regist", pageIndex: 2, index: $index).padding()
                                Divider()
                                NavigationButton(iconName: "gearshape.fill", title: "settings", pageIndex: 3, index: $index).padding()
                                Divider()
                                NavigationButton(iconName: "door.right.hand.open", title: "logout", pageIndex: 4, index: $index).padding()
                                Divider()
                            }
                            Spacer()
                        }
                    }
                }.offset(x: xOffset)
                
//                if isOpen {
//                }
                
                if isOpen {
                    Rectangle().frame(width: geometry.size.width * 0.2).ignoresSafeArea().foregroundStyle(.clear).overlay {
                        VStack(alignment: .leading){
                            Button(action: {
                                if isOpen {
                                    withAnimation {
                                        xOffset = 0
                                        isOpen.toggle()
                                    }
                                }
                            }, label: {
                                Image(systemName: "sidebar.leading")
                            }).transition(.slide).padding(.leading)
                            Spacer()
                            Divider().opacity(0)
                        }
                    }
                }
                
            }.onAppear(){
                xOffset = 0 - geometry.size.width * 0.2
            }
        })
    }
    
}

#Preview {
    ContentView()
}
