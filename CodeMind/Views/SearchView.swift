//
//  SearchView.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/28.
//

import SwiftUI

struct SearchView: View {
    @State var text = ""
    @State var show = false
    @Namespace var namespace
    @State var selectedIndex = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                // 搜索主内容
                VStack {
                    content
                }
                .padding(20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .strokeStyle(cornerRadius: 30)
                .padding(20)
                .background(
                    Rectangle()
                        .fill(.regularMaterial)
                        .frame(height: 200)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .blur(radius: 20)
                        .offset(y: -200)
                )
                .background(
                    Image("Blob 1").offset(x: -100, y: -200)
                )
                
            }
            // 始终弹出搜索框
            .searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("SwiftUI, Java, CodemyMind")) {
                // 搜索建议（提示）
                ForEach(suggestions) { suggestion in
                    // 选择了 一个建议后显示搜索结果
                    Button {
                        text = suggestion.text
                    } label: {
                        Text(suggestion.text)
                            // 选择 一个建议
                            .searchCompletion(suggestion.text)
                    }
                }
            }
            // 搜索框标题始终在小标题上
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            // 取消搜索栏
            .navigationBarItems(trailing: Button { presentationMode.wrappedValue.dismiss() } label: { Text("Done").bold() })
            // 点开显示数据
            .sheet(isPresented: $show) {
                CourseView(namespace: namespace, course: courses[selectedIndex], show: $show)
            }
        }
    }
    
    var content: some View {
        ForEach(Array(courses.enumerated()), id: \.offset) { index, item in
            // 搜索下面的详情显示
            if item.title.contains(text) || text == "" {
                // 分隔线
                if index != 0 { Divider() }
                Button {
                    show = true
                    // 获得相对应的ID ==> 方便点开后显示相对应的数据
                    selectedIndex = index
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        Image(item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .background(Color("background"))
                            .mask(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title).bold()
                                .foregroundColor(.primary)
                            Text(item.text)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                // 文本对齐
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.vertical, 4)
                    // 隐藏分隔符，令其工整好看
                    .listRowSeparator(.hidden)
                    
            }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
