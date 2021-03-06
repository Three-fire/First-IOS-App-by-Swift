//
//  Model.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/27.
//

import SwiftUI
import Combine

class Model: ObservableObject {
    @Published var showDetail: Bool = false
    
    @Published var selectedModal: Modal = .signIn
    
}

enum Modal: String {
    case signUp
    case signIn
}
