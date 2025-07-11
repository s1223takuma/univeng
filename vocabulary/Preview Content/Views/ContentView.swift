//
//  ContentView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State var isShowLogin:Bool = false
    var authenticationManager = AuthenticationManager()

    var body: some View {
        VStack {
            if authenticationManager.isSignIn == false {
                LoginView()
            } else {
                MainView()
            }
        }
    }
}

