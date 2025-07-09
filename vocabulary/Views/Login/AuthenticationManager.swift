//
//  AuthenticationManager.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/09.
//

import Foundation
import FirebaseAuth


@Observable class AuthenticationManager {
    private(set) var isSignIn: Bool = false
    private var handle: AuthStateDidChangeListenerHandle!

    init() {
        // ここで認証状態の変化を監視する（リスナー）
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let _ = user {
                self.isSignIn = true
            } else {
                self.isSignIn = false
            }
        }
    }

    deinit {
        // ここで認証状態の変化の監視を解除する
        Auth.auth().removeStateDidChangeListener(handle)
    }

    func passreset(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            print("送信しました！")
        }
    }

    func signin(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    completion(.failure(error))
                } else if let user = result?.user {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown authentication error"])))
                }
            }
        }
    func signup(email:String,password: String){
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }

        }


    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error")
        }
    }
}
