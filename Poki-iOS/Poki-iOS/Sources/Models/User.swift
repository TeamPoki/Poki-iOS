//
//  User.swift
//  Poki-iOS
//
//  Created by Insu on 10/16/23.
//

import UIKit


struct User: Codable {
    let userName: String
    let userImage: Data
    var likedPose: likePose
}

struct likePose: Codable {
    var firstPose: [Data]
    var secondPose: [Data]
    var thirdPose: [Data]
}
