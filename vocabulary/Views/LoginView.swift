//
//  Login.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import SwiftUI
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseOAuthUI
import FirebaseEmailAuthUI


struct LoginView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()!
        // ログイン方法を選択
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(authUI: authUI),
            FUIOAuth.appleAuthProvider(),
            FUIEmailAuth()
        ]
        authUI.providers = providers

        // FirebaseUIを表示する
        let authViewController = authUI.authViewController()

        return authViewController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // 処理なし
    }
}
