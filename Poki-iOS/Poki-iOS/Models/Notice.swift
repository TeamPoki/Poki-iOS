//
//  Notice.swift
//  Poki-iOS
//
//  Created by Insu on 10/20/23.
//

import UIKit

struct Notice {
    var title: String
    var date: String
}

struct NoticeData {
    static let noticeItems: [Notice] = [
        Notice(title: "중요한 공지사항", date: "2023.10.20"),
        Notice(title: "새로운 업데이트 안내", date: "2023.10.18"),
        Notice(title: "이벤트 참여 방법", date: "2023.10.15"),
        Notice(title: "긴 공지사항 입니다. 긴 공지사항입니다. 긴 공지사항 입니다. 긴 공지사항입니다. 긴 공지사항 입니다. 긴 공지사항입니다. 긴 공지사항 입니다. 긴 공지사항입니다.", date: "2023.10.20")
    ]
}
