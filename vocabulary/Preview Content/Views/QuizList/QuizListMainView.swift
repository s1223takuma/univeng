//
//  QuizListMainView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/01.
//

import SwiftUI

struct QuizListMainView: View {
    @State private var selection:Int = 0
    var body: some View {
        TabView{
            AllQuizListView()
                .tabItem{
                    Label("みんなの作ったクイズ", systemImage: "person.crop.circle")
                }
            MyQuizListView()
                .tabItem{
                    Label("あなたの作ったクイズ", systemImage: "folder.fill")
                }
        }
    }
}

#Preview {
    QuizListMainView()
}
