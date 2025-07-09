//
//  ContentView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State var isShowLogin = false
    var authenticationManager = AuthenticationManager()
    @State var firstlogin = false
    @State private var documentExists = false
    @State private var isChecking = true

    var body: some View {
        VStack {
            if authenticationManager.isSignIn == false {
                LoginView()
            } else {
                Text("Hello, World!")
                Button(action: {
                    authenticationManager.signOut()
                    DispatchQueue.main.async {
                        UIApplication.shared.connectedScenes
                            .compactMap { $0 as? UIWindowScene }
                            .flatMap { $0.windows }
                            .first?.rootViewController = UIHostingController(rootView: ContentView())
                    }
                }) {
                    Text("ログアウト")
                }
            }
        }
    }
}

