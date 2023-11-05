//
//  User.swift
//  Poki-iOS
//
//  Created by Insu on 10/16/23.
//

import UIKit

struct User: Codable {
    let nickname: String
    let imageURL: String
}

struct ImageData: Codable {
    var imageUrl: String
    var category: String
    var isSelected: Bool
}
