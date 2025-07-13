//
//  CategoryViewModel.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/13.
//

import FirebaseFirestore
import FirebaseAuth

class CategoryViewModel: ObservableObject {
    var authenticationManager = AuthenticationManager()
    private var db = Firestore.firestore()
    @Published private(set) var categorymodel: [CategoryModel] = []
    @Published var categoryNames: [String] = []

    func saveCategory(name: String,completion: @escaping (Error?) -> Void) {
        let docRef = db.collection("Category").document()

        let category = CategoryModel(id: docRef.documentID,name: name)

        docRef.setData([
            "id": category.id,
            "name": category.name
        ]) { error in
            completion(error)
        }
    }


    func fetchCategoryNames(completion: @escaping ([String]) -> Void) {
        db.collection("Category").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
                completion([])  // エラー時は空リスト返す
                return
            }

            guard let documents = snapshot?.documents else {
                completion([])
                return
            }

            // nameだけを抽出
            let names = documents.compactMap { doc in
                doc.data()["name"] as? String
            }

            completion(names)
        }
    }
    func fetchCategoryNames() {
        let db = Firestore.firestore()
        db.collection("Category").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            let names = documents.compactMap { $0.data()["name"] as? String }

            DispatchQueue.main.async {
                self.categoryNames = names
            }
        }
    }
}
