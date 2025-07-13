import SwiftUI

struct CreateQuizView: View {
    @State private var answer: String = ""
    @State private var question: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var words: [String] = ["", "Dart", "Swift", "Kotlin", "Go", "Python", "React"]
    @State private var selectword: String = ""
    @ObservedObject private var viewModel = QuizViewModel()
    @FocusState private var isFocused: Bool

    // アラート＆トースト表示用
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showToast = false

    var body: some View {
        ZStack {
            // 背景タップでキーボードを閉じる
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = false
                }

            Form {
                Section(header: Text("問題文")) {
                    TextEditor(text: $question)
                        .frame(minHeight: 120)
                        .focused($isFocused)
                }

                Section(header: Text("カテゴリー")) {
                    Picker("カテゴリーを選択", selection: $selectword) {
                        ForEach(words, id: \.self) { word in
                            Text(word)
                        }
                    }
                    Text(selectword != "" ? "\(selectword)を選択中" : "未選択")
                        .foregroundColor(selectword != "" ? .blue : .gray)
                }

                Section(header: Text("答え")) {
                    TextField("答えを入力", text: $answer)
                        .focused($isFocused)
                }

                Section {
                    Button(action: {
                        if question.trimmingCharacters(in: .whitespaces).isEmpty ||
                            answer.trimmingCharacters(in: .whitespaces).isEmpty ||
                            selectword.isEmpty {
                            alertMessage = "すべての項目を入力してください。"
                            showAlert = true
                        } else {
                            viewModel.saveQuiz(question: question, answer: answer, category: selectword) { error in
                                if let error = error {
                                    alertMessage = "保存に失敗しました: \(error.localizedDescription)"
                                    showAlert = true
                                } else {
                                    showToast = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        showToast = false
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }) {
                        Text("保存")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            // トースト表示
            if showToast {
                VStack {
                    Spacer()
                    Text("保存しました！")
                        .padding()
                        .background(Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: showToast)
                }
            }
        }
    }
}

#Preview {
    CreateQuizView()
}
