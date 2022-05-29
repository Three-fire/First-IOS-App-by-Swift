//
//  CodeMindApp.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/22.
//

import SwiftUI

@main
struct CodeMindApp: App {
    @StateObject var model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
