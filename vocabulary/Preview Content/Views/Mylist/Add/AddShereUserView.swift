//
//  AddShereUserView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/05.
//

import SwiftUI

struct AddShereUserView: View {
    let mylistid: String
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var isSaving = false
    @State private var successMessage: String?
    @State private var errorMessage: String?
    @ObservedObject var viewModel = MylistViewModel()

    var body: some View {
            VStack(spacing: 20) {
                // 説明テキスト
                Text("マイリストを共有したいユーザーのメールアドレスを入力してください")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top)

                // 入力欄
                TextField("メールアドレス", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // 保存ボタン
                Button(action: {
                    if email.isEmpty {
                        errorMessage = "メールアドレスを入力してください"
                        return
                    }
                    viewModel.addShereuser(usermail: email, mylistid: mylistid)
                    isSaving = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isSaving = false
                        successMessage = "共有ユーザーを追加しました"
                        errorMessage = nil
                    }
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("追加する")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // ローディング表示
                if isSaving {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .padding()
                }

                // メッセージ表示
                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .font(.caption)
                }
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Spacer()
            }
            .navigationTitle("共有ユーザー追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
        }
}
