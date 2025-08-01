//
//  SolveQuizView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/14.
//

import SwiftUI

struct SolveQuizView: View {
    @State private var input: String = ""
    @State private var isAnswered = false
    @State private var isCorrect = false
    @Environment(\.dismiss) private var dismiss
    let quiz: QuizModel

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("問題")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(quiz.question)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                TextField("あなたの答え", text: $input)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disabled(isAnswered)

                if isAnswered {
                    Text(isCorrect ? "⚪︎\n正解" : "×\n不正解\n答え：\(quiz.answer)")
                        .font(.headline)
                        .foregroundColor(isCorrect ? .green : .red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Button(action: {
                    if isAnswered{
                        dismiss()
                    }else{
                        checkAnswer()
                    }
                }) {
                    Text(isAnswered ? "閉じる" : "チェックする")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isAnswered ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }

    private func checkAnswer() {
        guard !isAnswered else { return }
        isCorrect = input.trimmingCharacters(in: .whitespacesAndNewlines) == quiz.answer
        isAnswered = true
    }
}
