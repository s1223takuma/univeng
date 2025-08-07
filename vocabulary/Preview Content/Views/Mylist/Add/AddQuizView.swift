//
//  AddShereUserView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/05.
//

import SwiftUI

struct AddQuizView: View {
    @Environment(\.dismiss) var dismiss

    // 検索
    @State private var searchText: String = ""

    // 仮のクイズデータ
    @State private var quizzes: [QuizModel] = [
        QuizModel(id: "q1", question: "日本の首都は？", answer: "東京", category: "地理", createuser: "u1", createuserdomain: "mail.com"),
        QuizModel(id: "q2", question: "3 + 5 は？", answer: "8", category: "数学", createuser: "u2", createuserdomain: "mail.com"),
        QuizModel(id: "q3", question: "月の英語は？", answer: "Moon", category: "英語", createuser: "u3", createuserdomain: "mail.com")
    ]

    var filteredQuizzes: [QuizModel] {
        if searchText.isEmpty {
            return quizzes
        } else {
            return quizzes.filter {
                $0.question.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // 検索バー
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("クイズを検索", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(10)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.horizontal)

            // クイズリスト
            List {
                ForEach(filteredQuizzes) { quiz in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(quiz.question)
                            .font(.headline)
                        Text("カテゴリ: \(quiz.category)")
                            .font(.caption)
                            .foregroundColor(.gray)

                        HStack {
                            Spacer()
                            Button {
                                // 追加処理（未実装）
                            } label: {
                                Label("追加", systemImage: "plus.circle")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("クイズ追加")
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
