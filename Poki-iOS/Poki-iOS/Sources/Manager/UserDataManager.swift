//
//  UserDataManager.swift
//  Poki-iOS
//
//  Created by 천광조 on 10/27/23.
//

import UIKit

final class UserDataManager {

    static var savedEmail: String? {
        UserDefaults.standard.string(forKey: "savedEmail")
    }

    // MARK: - 이메일 저장

    static func saveUserEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: "savedEmail")
    }

    static func deleteUserEmail() {
        UserDefaults.standard.removeObject(forKey: "savedEmail")
    }
}
