//
//  UsersViewModel.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/10.
//

import FirebaseFirestore
import FirebaseAuth

class UsersViewModel: ObservableObject {
    var authenticationManager = AuthenticationManager()
    private var db = Firestore.firestore()
    @Published private(set) var usermodel: [UsersModel] = []
    @Published var UserNames: [String] = []

    func saveUsername(name: String,point:Int,email:String,completion: @escaping (Error?) -> Void) {
        let docRef = db.collection("Users").document(Auth.auth().currentUser!.uid)

        let user = UsersModel(id: docRef.documentID,name: name,totalpoint:point, email: email)

        docRef.setData([
            "id": user.id,
            "name": user.name,
            "totalpoint": user.totalpoint,
            "email" : user.email
        ]) { error in
            completion(error)
        }
    }
    func fetchUsername() {
        let db = Firestore.firestore()
        db.collection("Users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            let names = documents.compactMap { $0.data()["name"] as? String }

            DispatchQueue.main.async {
                self.UserNames = names
            }
        }
    }
}
