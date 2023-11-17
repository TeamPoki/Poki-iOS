//
//  AuthManager.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/27.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    var currentUserUID: String? {
        let uid = Auth.auth().currentUser?.uid
        return uid
    }
    
    var currentUserEmail: String? {
        let email = Auth.auth().currentUser?.email
        return email
    }
    
    func loginUser(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signUpUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            print("로그아웃 성공!")
        } catch {
            print("로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    func userDelete(completion: @escaping (Error?) -> Void) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    
    func recertification(password: String, completion: @escaping (Error?) -> Void) {
        guard let userEmail = self.currentUserEmail else { return }
        let user = Auth.auth().currentUser
        let email = EmailAuthProvider.credential(withEmail: userEmail, password: password)
        user?.reauthenticate(with: email) { result, error in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    
    func sendPasswordReset(with email: String?) {
        guard let email = email else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("ERROR: 비밀번호 초기화 메일 보내기 실패! \(error)")
            }
            // 이메일이 존재하는지 검증하는 로직이 필요할까요..?
            print("비밀번호 초기화 메일 보내기 성공!")
        }
    }
    
    // 로그인, 회원가입 시 유효성 검사 메서드
    func isValid(form: String?, regex: String) -> Bool {
        guard let value = form else { return false }
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: value)
    }
}
