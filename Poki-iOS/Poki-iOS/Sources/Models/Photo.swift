//
//  Photo.swift
//  Poki-iOS
//
//  Created by Insu on 10/16/23.
//

import UIKit

struct Photo: Codable {
    var id: String
    var image: String
    var memo: String
    var date: String
    var tag: TagModel

    enum CodingKeys: String, CodingKey {
        case id
        case image
        case memo
        case date
        case tag
    }
}
