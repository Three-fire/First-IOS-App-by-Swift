//
//  Animations.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/27.
//

import SwiftUI

extension Animation {
    static let openCard = Animation.spring(response: 0.5, dampingFraction: 0.7)
    static let closeCard = Animation.spring(response: 0.6, dampingFraction: 0.9)
}
