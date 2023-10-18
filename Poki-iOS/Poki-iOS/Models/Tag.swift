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
    TagModel(tagLabel: "인생네컷", tagImage: #imageLiteral(resourceName: "lifefourcuts-logo")),
    TagModel(tagLabel: "하루필름", tagImage: #imageLiteral(resourceName: "harufilm-logo")),
    TagModel(tagLabel: "셀픽스", tagImage: #imageLiteral(resourceName: "selfix-logo")),
    TagModel(tagLabel: "포토아이브", tagImage: #imageLiteral(resourceName: "photoive-logo")),
    TagModel(tagLabel: "포토그레이", tagImage: #imageLiteral(resourceName: "photogray-logo")),
    TagModel(tagLabel: "포토 시그니쳐", tagImage: #imageLiteral(resourceName: "photosignature-logo")),
    TagModel(tagLabel: "포토드링크", tagImage: #imageLiteral(resourceName: "photodrink-logo")),
    TagModel(tagLabel: "포토이즘", tagImage: #imageLiteral(resourceName: "photoism-logo")),
    TagModel(tagLabel: "모노맨션", tagImage: #imageLiteral(resourceName: "monomansion-logo")),
    TagModel(tagLabel: "플레이인더박스", tagImage: #imageLiteral(resourceName: "playinthebox-logo")),
    TagModel(tagLabel: "비분류 브랜드", tagImage: #imageLiteral(resourceName: "addButton"))
    ]
}
