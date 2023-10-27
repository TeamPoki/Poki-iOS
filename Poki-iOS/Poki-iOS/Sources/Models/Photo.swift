//
//  Photo.swift
//  Poki-iOS
//
//  Created by Insu on 10/16/23.
//

import UIKit

struct Photo: Codable {
    var documentReference: String
    var image: String
    var memo: String
    var date: String
    var tag: TagModel

    enum CodingKeys: String, CodingKey {
        case documentReference
        case image
        case memo
        case date
        case tag
    }
}
