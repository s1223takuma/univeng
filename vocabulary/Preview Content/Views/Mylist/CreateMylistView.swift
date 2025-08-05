//
//  CreateMylistView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/04.
//

import SwiftUI

struct CreateMylistView: View {
    @StateObject private var viewModel = MylistViewModel()
    @State private var title: String = ""
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("新しいマイリストを作成")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            TextField("マイリスト", text: $title)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2))
                )
                .padding(.horizontal)

            if isSaving {
                ProgressView("保存中...")
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(.caption)
            }

            Button(action: {
                if title.isEmpty{
                    title = "マイリスト"
                }

                isSaving = true
                errorMessage = nil
                successMessage = nil

                viewModel.saveMylist(title: title) { error in
                    isSaving = false
                    if let error = error {
                        self.errorMessage = "保存に失敗: \(error.localizedDescription)"
                    } else {
                        self.successMessage = "保存に成功しました！"
                        self.title = ""
                    }
                    dismiss()
                }
            }) {
                Text("保存する")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}
