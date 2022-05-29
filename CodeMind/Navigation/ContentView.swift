//
//  ContentView.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/22.
//

import SwiftUI

struct ContentView: View {
    // 关闭退出后，AppStorage也会记住关闭前的状态
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @AppStorage("showModal") var showModal = false
    // 环境对象 ==> No persistent
    @EnvironmentObject var model: Model
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            switch selectedTab {
            case .home:
                HomeView()
            case .explore:
                AccountView()
            case .notifications:
                AccountView()
            case .library:
                AccountView()
            }
            // 底部栏
            TabBar()
                // 点开cards则下挪来隐藏底部TarBar，关闭cardsDetail则展示TarBar
                .offset(y: model.showDetail ? 200 : 0)
            
            // 点击小头像后弹出SignUpView
            if showModal {
                ZStack {
                    Color.clear.background(.regularMaterial)
                        .ignoresSafeArea()
                    
                    // SignUpView 
                    SignUpView()
                    
                    // 关闭按钮
                    Button {
                        withAnimation {
                            showModal = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.bold))
                            .foregroundColor(.secondary)
                            .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(20)
                }
                // 令其正常过渡
                .zIndex(1)
            }
        }
        // 滚动条不越界Tab Bar
        .safeAreaInset(edge: .bottom) {
            // 此处只是为了清楚feel到界限
            Color.clear.frame(height: 44)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(Model())
    }
}
