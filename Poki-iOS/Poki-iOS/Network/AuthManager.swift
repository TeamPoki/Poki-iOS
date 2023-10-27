//
//  AuthManager.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/27.
//

import UIKit
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    func loginUser(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
     }
    
    func signUpUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
}
