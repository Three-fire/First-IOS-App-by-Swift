//
//  HomeView.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/25.
//

import SwiftUI

struct HomeView: View {
    @State var hasScrolled = false
    // 动画在多个视图存在（调用的）的空间
    @Namespace var namespace
    @State var show = false
    @State var showStatusBar = true
    @State var selectdID = UUID()
    @State var showCourse = false
    @State var selectedIndex = 0
    // 环境对象，各个Views都可调用
    @EnvironmentObject var model: Model
    
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                // 滚动检测
                scrollDetection
                
                // TabView分页滑动展示
                featured
                
                Text("Courses".uppercased())
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal,20)
                
                // 适应不同设备不同尺寸的布局
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 20)], spacing: 20) {
                    // Courses引用课程 ==> 可点开
                    if !show {
                        
                        // 主页cards
                        cards
                        
                    } else {
                        // 为每个选中点击的cards留一个占位符 ==> 以便关闭cardsDetail后定位回当前cards
                        ForEach(courses) { course in
                            Rectangle()
                                .fill(.white)
                                .frame(height: 300)
                                .cornerRadius(30)
                                .shadow(color: Color("Shadow"), radius: 20, x: 0, y: 10)
                                .opacity(0.3)
                            .padding(.horizontal, 30)
                        }
                    }
                }
                .padding(.horizontal, 20)
    
            }
            // 坐标空间
            .coordinateSpace(name: "scroll")
            // 滚动条在安全区内，不越界Nav Bar
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: 70)
            })
            .overlay(
                // 顶部Navigation Bar
                NavigationBar(title: "Featured", hasScrolled: $hasScrolled)
            )
            
            // 点开课程组件后的展示View
            if show {
                // 点开主页cards后的cardsDetail页
                cardsDetail
            }
        }
        // 顶部状态栏的变化
        .statusBar(hidden: !showStatusBar)
        .onChange(of: show) { newValue in
            withAnimation(.closeCard) {
                if newValue {
                    showStatusBar = false
                } else {
                    showStatusBar = true
                }
            }
        }
        
    }
    
    // 滚动检测
    var scrollDetection: some View {
        GeometryReader { proxy in
            // 滚动条移动的值
            //  Text("\(proxy.frame(in: .named("scroll")).minY)")
            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
            // 过渡动画
            withAnimation(.easeInOut) {
                if value < 0 {
                    hasScrolled = true
                } else {
                    hasScrolled = false
                }
            }
        })
    }
    
    //TabView分页滑动展示
    var featured: some View {
        TabView {
            // Featured组件
            ForEach(Array(featuredCourses.enumerated()), id: \.offset) { index, course in
                GeometryReader { proxy in
                    let minX = proxy.frame(in: .global).minX
                    
                    FeaturedItem(course: course)
                        .frame(maxWidth: 500)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        // 旋转3D效果
                        .rotation3DEffect(.degrees(minX / -10), axis: (x: 0, y: 1, z: 0))
                        // 阴影要在3d效果后才能生效
                        .shadow(color: Color("Shadow").opacity(0.3), radius: 10, x: 0, y: 10)
                        // 模糊文本
                        .blur(radius: abs(minX / 40))
                        .overlay(
                            Image(course.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 230)
                                .offset(x: 32, y: -80)
                            // 视觉差parallax effect
                                .offset(x: minX / 2)
                        )
                        .onTapGesture {
                            showCourse = true
                            selectedIndex = index
                        }
                    // Text("\(proxy.frame(in: .global).minX)")
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 430)
        .background(Image("Blob 1").offset(x: 250, y: -100))
        // 点开TabView卡片后展示相应的数据
        .sheet(isPresented: $showCourse) {
            CourseView(namespace: namespace,course: featuredCourses[selectedIndex], show: $showCourse)
        }
    }
    
    var cards: some View {
        ForEach(courses) { course in
            CourseItem(namespace: namespace,course: course, show: $show)
                .onTapGesture {
                    withAnimation(.openCard) {
                        show.toggle()
                        model.showDetail.toggle()
                        showStatusBar = false
                        selectdID = course.id
                    }
            }
        }
    }
    
    var cardsDetail: some View {
        ForEach(courses) { course in
            if course.id == selectdID {
                CourseView(namespace: namespace,course: course, show: $show)
                    // Not instantly disappear anymore
                    .zIndex(1)
                    // 更完美的tarnsition
                    .transition(.asymmetric(
                        insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                        removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2)))
                )
            }
            
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
            .environmentObject(Model())     //若无此代码则会引发preview crashed
    }
}
