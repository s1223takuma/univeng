//
//  AnswerQuizView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/13.
//

import SwiftUI

struct SolveMyQuizListView: View {
    @State private var isFocused: Bool = false
    @ObservedObject private var viewModel = QuizViewModel()

    var body: some View {

            VStack {
                Text("自分のクイズ一覧")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)

                List {
                    ForEach(viewModel.quizmodel) { quiz in
                        ZStack {
                            NavigationLink(destination: MainView()) {
                                EmptyView()
                            }
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.clear)

                            VStack(alignment: .leading, spacing: 8) {
                                Text(quiz.question)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                            .padding(.vertical, 4)
                            .padding(.horizontal)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
            }
        .onAppear {
            viewModel.fetchMyQuizzes()
        }
    }
}




#Preview {
    SolveMyQuizListView()
}
