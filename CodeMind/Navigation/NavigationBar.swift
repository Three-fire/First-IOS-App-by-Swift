//
//  NavigationBar.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/25.
//

import SwiftUI

struct NavigationBar: View {
    // 自定义Nav Bar名字
    var title = ""
    @Binding var hasScrolled: Bool
    @State var showSearch = false
    @State var showAccount = false
    @AppStorage("showModal") var showModal = false
    
    var body: some View {
            // 顶部Navigation Bar
            ZStack {
                Color.clear
                    .background(.ultraThinMaterial)
                    // 渐进色
                    .blur(radius: 10)
                    .opacity(hasScrolled ? 1 : 0)
                
                Text(title)
                    // 自定义动画，改变title大小、weight 以动画形式（more fluent）
                    .animatableFont(size: hasScrolled ? 22 : 34, weight: .bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    // 滑动时将Nav Bar标题上移一些 ==> Nav Bar占用空间缩小更美观
                    .offset(y: hasScrolled ? -4 : 0)
                
                HStack(spacing: 16) {
                    Button {
                        showSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.body.weight(.bold))
                            .frame(width: 36, height: 36)
                            .foregroundColor(.secondary)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .strokeStyle(cornerRadius: 14)
                    }
                    // 调用SearchView模块显示
                    .sheet(isPresented: $showSearch) {
                        SearchView()
                    }
                    
                    Button {
//                        showAccount = true
                        withAnimation {
                            showModal = true
                        }
                    } label: {
                        Image("Avatar Default")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .cornerRadius(10)
                            .padding(8)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .strokeStyle(cornerRadius: 18)
                    }
                    // 调用AccountView模块显示
                    .sheet(isPresented: $showAccount) {
                        AccountView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
                .padding(.top, 20)
                // 滑动时将图标上移一些
                .offset(y: hasScrolled ? -4 : 0)
            }
            // 滚动时滚动条长44，否则70
            .frame(height: hasScrolled ? 44 : 70)
            .frame(maxHeight: .infinity, alignment: .top)

    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "Featured", hasScrolled: .constant(false))
    }
}
