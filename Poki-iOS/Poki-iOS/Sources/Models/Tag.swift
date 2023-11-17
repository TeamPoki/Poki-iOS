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
        TagModel(tagLabel: "인생네컷", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Brand%2F%E1%84%8B%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A2%E1%86%BC%E1%84%82%E1%85%A6%E1%84%8F%E1%85%A5%E1%86%BA.png?alt=media&token=24926b12-73f7-41d6-8ab1-100561362622"),
        TagModel(tagLabel: "하루필름", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Brand%2F%E1%84%92%E1%85%A1%E1%84%85%E1%85%AE%E1%84%91%E1%85%B5%E1%86%AF%E1%84%85%E1%85%B3%E1%86%B7.png?alt=media&token=a8186500-9623-4267-8445-8de7075ef4ff"),
        TagModel(tagLabel: "셀픽스", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Brand%2F%E1%84%89%E1%85%A6%E1%86%AF%E1%84%91%E1%85%B5%E1%86%A8%E1%84%89%E1%85%B3.png?alt=media&token=d0773def-0383-4148-8598-5d203b0f4bae"),
        TagModel(tagLabel: "포토아이브", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Brand%2F%E1%84%91%E1%85%A9%E1%84%90%E1%85%A9%E1%84%8B%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%87%E1%85%B3.png?alt=media&token=4eb3405f-5b70-44f2-b02b-42964c18ea66"),
        TagModel(tagLabel: "포토그레이", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Brand%2F%E1%84%91%E1%85%A9%E1%84%90%E1%85%A9%E1%84%80%E1%85%B3%E1%84%85%E1%85%A6%E1%84%8B%E1%85%B5.png?alt=media&token=6568ae32-416d-4433-a3fa-98a0d9567559"),
        TagModel(tagLabel: "포토 시그니쳐", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Brand%2F%E1%84%91%E1%85%A9%E1%84%90%E1%85%A9%E1%84%89%E1%85%B5%E1%84%80%E1%85%B3%E1%84%82%E1%85%B5%E1%84%8E%E1%85%A5.png?alt=media&token=156e0ea9-cd88-4297-9bb0-c0711e962c35"),
        TagModel(tagLabel: "포토드링크", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Brand%2F%E1%84%91%E1%85%A9%E1%84%90%E1%85%A9%E1%84%83%E1%85%B3%E1%84%85%E1%85%B5%E1%86%BC%E1%84%8F%E1%85%B3.png?alt=media&token=954eda82-d4fe-4be4-8cbd-9a81d220f4b7"),
        TagModel(tagLabel: "포토이즘", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Brand%2F%E1%84%91%E1%85%A9%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%E1%84%8C%E1%85%B3%E1%86%B7.png?alt=media&token=68f808a2-d528-4624-83e5-ca22c3757220"),
        TagModel(tagLabel: "모노맨션", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Brand%2F%E1%84%86%E1%85%A9%E1%84%82%E1%85%A9%E1%84%86%E1%85%A6%E1%86%AB%E1%84%89%E1%85%A7%E1%86%AB.png?alt=media&token=6e8c31a2-f1d6-4f7c-8828-76f2798f1c95"),
        TagModel(tagLabel: "플레이인더박스", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Brand%2F%E1%84%91%E1%85%B3%E1%86%AF%E1%84%85%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%B5%E1%86%AB%E1%84%83%E1%85%A5%E1%84%87%E1%85%A1%E1%86%A8%E1%84%89%E1%85%B3.png?alt=media&token=25acd777-0bd4-4138-8898-b6320985a065"),
        TagModel(tagLabel: "비분류 브랜드", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Group%2061116.png?alt=media&token=66f5fb03-cd1a-4d74-aa0d-1f781cdd9879&_gl=1*3i3q4a*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDQ3My40Ny4wLjA.")
    ]
}
