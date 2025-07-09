//
//  ContentView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import SwiftUI


struct ContentView: View {
    @State var isShowLogin = false
    var body: some View {
        VStack {
            Button("ログイン") {
                isShowLogin .toggle()
            }
            Spacer()
                .sheet(isPresented: $isShowLogin) {
                    LoginView()
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
