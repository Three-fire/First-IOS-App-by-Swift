//
//  Suggestion.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/28.
//

import SwiftUI

struct Suggestion: Identifiable {
    let id = UUID()
    var text: String
}

var suggestions = [
    Suggestion(text: "SwiftUI"),
    Suggestion(text: "Java"),
    Suggestion(text: "Code")
]
