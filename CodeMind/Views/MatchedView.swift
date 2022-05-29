//
//  MatchedView.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/26.
//
//  Matched Geomotry Effect
//  自定义transition ==> 使其动画过渡变得天衣无缝

import SwiftUI

struct MatchedView: View {
    // 动画在多个视图存在（调用的）的空间
    @Namespace var namespace
    @State var show = false
    
    var body: some View {
        ZStack {
            if !show {
                
            }else {
                
            }
        }

    }
}

struct MatchedView_Previews: PreviewProvider {
    static var previews: some View {
        MatchedView()
    }
}
