//
//  maildomain.swift
//  vocabulary
//
//  Created by 関琢磨 on 2025/08/01.
//

import Foundation

class checkmaildomain:ObservableObject {
    func check(mail:String?) -> Bool {
        if mail!.contains("@tama.ac.jp") == false {
            return false
        }
        return true
    }
}
