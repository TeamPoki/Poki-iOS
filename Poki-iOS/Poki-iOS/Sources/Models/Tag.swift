//
//  Tag.swift
//  Poki-iOS
//
//  Created by Insu on 10/16/23.
//

import UIKit

struct TagModel: Codable {
    var tagLabel: String
    var tagImage: String

    enum CodingKeys: String, CodingKey {
        case tagLabel
        case tagImage
    }
}

struct TagData {
    static let data: [TagModel] = [
        TagModel(tagLabel: "인생네컷", tagImage: "gs://poki-ios-87d7e.appspot.com/Frame 61138.png"),
        TagModel(tagLabel: "하루필름", tagImage: "gs://poki-ios-87d7e.appspot.com/Frame 61147.png"),
        TagModel(tagLabel: "셀픽스", tagImage: "gs://poki-ios-87d7e.appspot.com/Frame 61137.png"),
        TagModel(tagLabel: "포토아이브", tagImage: "gs://poki-ios-87d7e.appspot.com/Frame 61144.png"),
        TagModel(tagLabel: "포토그레이", tagImage: "gs://poki-ios-87d7e.appspot.com/Frame 61145.png"),
        TagModel(tagLabel: "포토 시그니쳐", tagImage: "gs://poki-ios-87d7e.appspot.com/Frame 61143.png"),
        TagModel(tagLabel: "포토드링크", tagImage: "gs://poki-ios-87d7e.appspot.com/Frame 61146.png"),
        TagModel(tagLabel: "포토이즘", tagImage: "gs://poki-ios-87d7e.appspot.com/Frame 61139.png"),
        TagModel(tagLabel: "모노맨션", tagImage: "gs://poki-ios-87d7e.appspot.com/Frame 61142.png"),
        TagModel(tagLabel: "플레이인더박스", tagImage: "gs://poki-ios-87d7e.appspot.com/Frame 61148.png"),
        TagModel(tagLabel: "비분류 브랜드", tagImage: "gs://poki-ios-87d7e.appspot.com/Group 61116.png")
    ]
}
