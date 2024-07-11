//
//  SideBarView.swift
//  LogiSyncManager
//
//  Created by 広瀬友哉 on 2024/07/09.
//

import SwiftUI

struct SideBarView: View {
    
    @State var isOpen: Bool = false
    @State var xOffset: CGFloat = .zero
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack{
                Group{
                    Rectangle().frame(width: geometry.size.width * 0.2).ignoresSafeArea().foregroundStyle(Material.ultraThin)
                    VStack{
                        Button(action: {
                            if !isOpen {
                                withAnimation {
                                    xOffset = 0 - geometry.size.width * 0.2
                                    isOpen.toggle()
                                }
                            } else {
                                
                            }
                        }, label: {
                            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                        })
                        Text("logisync").textCase(.uppercase).bold().font(.title).padding(.bottom, 50)
                        HStack{
                            Image(systemName: "person.2").bold()
                            Text("matching").textCase(.uppercase).bold()
                        }
                        Spacer()
                    }
                }.offset(x: xOffset)
                
                if isOpen {
                    Button(action: {
                        if isOpen {
                            withAnimation {
                                xOffset = 0
                                isOpen.toggle()
                            }
                        }
                    }, label: {
                        /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                    }).transition(.slide)
                }
                
            }
        })
    }
}

#Preview {
    SideBarView()
}
