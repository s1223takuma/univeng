//
//  MainView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import SwiftUI

struct MainView: View {
    var authenticationManager = AuthenticationManager()
    var body: some View {
        NavigationView{
            VStack {
                VStack{
                    NavigationLink(destination: CreateQuizView()) {
                        Text("問題を作る")
                    }.padding()

                }
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

#Preview{
    MainView()
}
