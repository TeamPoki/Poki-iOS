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
        TagModel(tagLabel: "인생네컷", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Frame%2061138.png?alt=media&token=836963b3-c4da-4142-931c-e25cd91dae31&_gl=1*jwb32b*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDMzNy40MC4wLjA."),
        TagModel(tagLabel: "하루필름", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Frame%2061147.png?alt=media&token=4eeedd8d-9abf-44d8-95f3-01ffbc1ba431&_gl=1*1gqkjm5*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDQ2NS41NS4wLjA."),
        TagModel(tagLabel: "셀픽스", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Frame%2061137.png?alt=media&token=e1b0ed5a-845e-4bfc-9782-77fe4035ce31&_gl=1*latkmd*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk4OTU5Ni42MC4wLjA."),
        TagModel(tagLabel: "포토아이브", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Frame%2061144.png?alt=media&token=faab05e9-0df6-4dbc-9523-6d8ab0f17ac0&_gl=1*1t13xd7*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDM4MS41OC4wLjA."),
        TagModel(tagLabel: "포토그레이", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Frame%2061145.png?alt=media&token=37c200a1-e6ef-4bff-809e-b781af71d019&_gl=1*i0p6sj*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDQyMi4xNy4wLjA."),
        TagModel(tagLabel: "포토 시그니쳐", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Frame%2061143.png?alt=media&token=c6547438-4ce1-44f5-8c59-c33d7390da0c&_gl=1*1i674ad*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDM3Ni4xLjAuMA.."),
        TagModel(tagLabel: "포토드링크", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Frame%2061146.png?alt=media&token=5193cc83-5114-4850-8c43-1700b57963f0&_gl=1*1eyg90e*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDQ2MC42MC4wLjA."),
        TagModel(tagLabel: "포토이즘", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Frame%2061139.png?alt=media&token=39785e5a-f9b9-499a-b2f7-f8f2dd8d95af&_gl=1*18ezb3l*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDM2Ni4xMS4wLjA."),
        TagModel(tagLabel: "모노맨션", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Frame%2061142.png?alt=media&token=d8e2f42d-8e2f-49ed-b0a7-e4f84564232a&_gl=1*12xupsc*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDM3MC43LjAuMA.."),
        TagModel(tagLabel: "플레이인더박스", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Frame%2061148.png?alt=media&token=faf31e94-0f95-4fb1-a0ac-828057c49ec2&_gl=1*1bi98ld*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDQ2OS41MS4wLjA."),
        TagModel(tagLabel: "비분류 브랜드", tagImage: "https://firebasestorage.googleapis.com/v0/b/poki-ios-87d7e.appspot.com/o/Group%2061116.png?alt=media&token=66f5fb03-cd1a-4d74-aa0d-1f781cdd9879&_gl=1*3i3q4a*_ga*MzI1NjE1OTMzLjE2OTg5ODk0NDY.*_ga_CW55HF8NVT*MTY5ODk4OTQ0Ni4xLjEuMTY5ODk5MDQ3My40Ny4wLjA.")
    ]
}
