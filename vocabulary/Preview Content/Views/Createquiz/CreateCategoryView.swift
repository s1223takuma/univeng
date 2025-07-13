//
//  CreateCategoryView.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/13.
//

import SwiftUI

struct CreateCategoryView: View {
    @State private var categoryname: String = ""
    @ObservedObject private var viewmodel = CategoryViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("カテゴリー名")) {
                    TextField("カテゴリー名を入力", text: $categoryname)
                        .focused($isFocused)
                }

                Section {
                    Button(action: {
                        guard !categoryname.trimmingCharacters(in: .whitespaces).isEmpty else {
                            alertMessage = "カテゴリー名を入力してください"
                            showAlert = true
                            return
                        }

                        viewmodel.saveCategory(name: categoryname) { error in
                            if let error = error {
                                alertMessage = "保存に失敗しました: \(error.localizedDescription)"
                                showAlert = true
                            } else {
                                viewmodel.fetchCategoryNames()
                                dismiss()
                            }
                        }
                    }) {
                        Text("保存する")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("カテゴリー作成")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("エラー"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}


#Preview {
    CreateCategoryView()
}
