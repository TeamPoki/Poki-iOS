//
//  Tag.swift
//  Poki-iOS
//
//  Created by Insu on 10/16/23.
//

import UIKit

struct TagModel {
    let tagLabel: String
    let tagImage: UIImage
}


struct TagData {
   static let data:[TagModel] = [
    TagModel(tagLabel: "인생네컷", tagImage: #imageLiteral(resourceName: "인생네컷")),
    TagModel(tagLabel: "하루필름", tagImage: #imageLiteral(resourceName: "하루필름")),
    TagModel(tagLabel: "셀픽스", tagImage: #imageLiteral(resourceName: "셀픽스")),
    TagModel(tagLabel: "포토아이브", tagImage: #imageLiteral(resourceName: "포토아이브")),
    TagModel(tagLabel: "포토그레이", tagImage: #imageLiteral(resourceName: "포토그레이")),
    TagModel(tagLabel: "포토 시그니쳐", tagImage: #imageLiteral(resourceName: "포토시그니처")),
    TagModel(tagLabel: "포토드링크", tagImage: #imageLiteral(resourceName: "포토드링크")),
    TagModel(tagLabel: "포토이즘", tagImage: #imageLiteral(resourceName: "포토이즘")),
    TagModel(tagLabel: "모노맨션", tagImage: #imageLiteral(resourceName: "모노멘션")),
    TagModel(tagLabel: "플랜비스튜디오", tagImage: #imageLiteral(resourceName: "플랜비스튜디오")),
    TagModel(tagLabel: "비분류 브랜드", tagImage: #imageLiteral(resourceName: "addButton"))
    ]
}
