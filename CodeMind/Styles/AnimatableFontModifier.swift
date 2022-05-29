//
//  AnimatableFontModifier.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/25.
//
// 定制字体以动画形式改变

import SwiftUI

struct AnimatableFontModifier: AnimatableModifier {
    var size: Double
    var weight: Font.Weight = .regular
    var design: Font.Design = .default
    
    // 更新动画数据
    var animatableData: Double {
        get { size }
        set { size  = newValue}
    }
    
    // 更新时自定义
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}

// 方便调用此modifier
extension View {
    func animatableFont(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        // 引用视图本身
        self.modifier(AnimatableFontModifier(size: size, weight: weight, design: design))
    }
}
