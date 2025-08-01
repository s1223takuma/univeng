//
//  QuizCardView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/14.
//

import SwiftUI

struct QuizCardView: View {
    let quiz:QuizModel
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quiz.question)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 4)

            Text("カテゴリ: \(quiz.category)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
