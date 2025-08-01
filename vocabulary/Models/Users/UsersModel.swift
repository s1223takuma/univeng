//
//  UserModel.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/07/10.
//

import FirebaseFirestore

struct UsersModel: Identifiable{
    var id: String
    var name: String
    var totalpoint: Int
    var email: String
}
