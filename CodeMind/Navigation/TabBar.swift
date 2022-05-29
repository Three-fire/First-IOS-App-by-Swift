//
//  TabBar.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/24.
//
//  Custom Tab Bar  ==> use Tab.swift for Data Model

import SwiftUI

struct TabBar: View {
    
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @State var color: Color = .teal
    @State var tabItemWidth: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            // 确定底部或顶部的大小
            let hasHomeIndicator = proxy.safeAreaInsets.bottom > 20
            // Tab Bar标签栏
            HStack {
                buttons
            }
            .padding(.horizontal, 8)
            .padding(.top, 14)
            .frame(height: hasHomeIndicator ? 88 : 62, alignment: .top)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: hasHomeIndicator ? 34 : 0 , style: .continuous))
            // Tab背后小圈圈效果, 并通过spacer定位到各个Tab背后
            .background(
                background
            )
            // Tab上的横线
            .overlay(
                overlay
            )
            .strokeStyle(cornerRadius: hasHomeIndicator ? 34 : 0)
            .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        }
    }
    
    // 底部4个Tab
    var buttons: some View {
            // 水平放置等大的Tab
            ForEach(tabItems) { item in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = item.tab
                        color = item.color
                    }
                    
                } label: {
                    VStack(spacing: 0) {
                        Image(systemName: item.icon)
                                .symbolVariant(.fill)
                                .font(.body.bold())
                                .frame(width: 44, height: 29)
                        Text(item.text)
                                .font(.caption2)
                                .lineLimit(1)
                    }
                    // 令每个Tab占的面积等同大
                    .frame(maxWidth: .infinity)
                }
                .foregroundStyle(selectedTab == item.tab ? .primary : .secondary)
                // 颜色融合，看着更舒服些
                .blendMode(selectedTab == item.tab ? .overlay : .normal)
                
                .overlay(
                    // 用GeometryReader检测Button的大小 ==> 自适应不同方向、大小的屏幕
                    GeometryReader { proxy in
//                          Text("\(proxy.size.width)")

                        // proxy is passed to the state ==> set a prefernceKey and update that
                        Color.clear.preference(key: TabPreferenceKey.self, value: proxy.size.width)
                    }
                )
                // 监听preferencekey的变化，更新状态
                .onPreferenceChange(TabPreferenceKey.self) { value in
                    tabItemWidth = value
                }
            }
    }
    
    // 利用Spacer将小圆圈强行定位至每个Tab背后
    var background: some View {
        HStack {
            if selectedTab == .library { Spacer() }
            if selectedTab == .explore { Spacer() }
            if selectedTab == .notifications {
                Spacer()
                Spacer()
            }
            // 自适应布局大小
            Circle().fill(color).frame(width: tabItemWidth)
            if selectedTab == .home { Spacer() }
            if selectedTab == .explore {
                Spacer()
                Spacer()
            }
            if selectedTab == .notifications { Spacer() }
        }
        .padding(.horizontal, 8)
    }
    
    // Tab上的横线跟随移动
    var overlay: some View {
        HStack {
            if selectedTab == .library { Spacer() }
            if selectedTab == .explore { Spacer() }
            if selectedTab == .notifications {
                Spacer()
                Spacer()
            }
            Rectangle().fill(color).frame(width: 28, height:5)
                .cornerRadius(3)
                // 自适应大小
                .frame(width: tabItemWidth)
                .frame(maxHeight: .infinity, alignment: .top)
            if selectedTab == .home { Spacer() }
            if selectedTab == .explore {
                Spacer()
                Spacer()
            }
            if selectedTab == .notifications { Spacer() }
        }
        .padding(.horizontal, 8)
    }
}


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .previewInterfaceOrientation(.portrait)
    }
}
