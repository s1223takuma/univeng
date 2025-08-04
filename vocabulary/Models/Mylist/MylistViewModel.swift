//
//  MylistViewModel.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/03.
//


import FirebaseFirestore
import FirebaseAuth

class MylistViewModel: ObservableObject {
    var authenticationManager = AuthenticationManager()
    private var db = Firestore.firestore()
    @Published private(set) var mylistmodel: [MylistModel] = []
    @Published private(set) var mylistlinkmodel: [MylistLinkModel] = []

    func saveMylist(title: String,completion: @escaping (Error?) -> Void){
        let docRef = db.collection("Mylist").document()

        let mylist = MylistModel(id: docRef.documentID,title:title,createuser:Auth.auth().currentUser?.uid ?? "",shereuser: [Auth.auth().currentUser?.email ?? ""])

        docRef.setData([
            "id": mylist.id,
            "title": mylist.title,
            "createuser": mylist.createuser,
            "shereuser": mylist.shereuser
        ]) { error in
            completion(error)
        }
    }

    func fetchMyLists() {
        guard let mail = Auth.auth().currentUser?.email else { return }
        db.collection("Mylist")
            .whereField("shereuser",arrayContains: mail)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    DispatchQueue.main.async {
                        self.mylistmodel = documents.compactMap { doc in
                            let data = doc.data()
                            return MylistModel(
                                id: doc.documentID,
                                title: data["title"] as? String ?? "",
                                createuser: data["createuser"] as? String ?? "",
                                shereuser: data["shereuser"] as? [String] ?? []
                            )
                        }
                    }
                }
            }
    }

}
