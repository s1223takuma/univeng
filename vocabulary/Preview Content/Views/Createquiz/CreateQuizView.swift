import SwiftUI

struct CreateQuizView: View {
    @State private var answer: String = ""
    @State private var question: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var selectword: String = ""
    @State private var istoggle: Bool = false

    @ObservedObject private var viewModel = QuizViewModel()
    @ObservedObject private var categoryviewModel = CategoryViewModel()

    @FocusState private var isFocused: Bool

    // アラート＆トースト表示用
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showToast = false

    var body: some View {
        ZStack {
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
                    if categoryviewModel.categoryNames.isEmpty {
                        ProgressView("カテゴリーを読み込み中…")
                    } else {
                        Picker("カテゴリーを選択", selection: $selectword) {
                            ForEach(categoryviewModel.categoryNames, id: \.self) { name in
                                Text(name)
                            }
                        }
                        Text(selectword != "" ? "\(selectword)を選択中" : "未選択")
                            .foregroundColor(selectword != "" ? .blue : .gray)
                    }
                    Button(action:{
                        istoggle = true
                    }){
                        Text("新しいカテゴリーを作る")
                    }
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
            .onAppear {
                categoryviewModel.fetchCategoryNames()
            }
            .sheet(isPresented: $istoggle,onDismiss: {
                categoryviewModel.fetchCategoryNames()
            }) {
                CreateCategoryView()
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
