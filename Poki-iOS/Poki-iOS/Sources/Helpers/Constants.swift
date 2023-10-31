//
//  Constants.swift
//  Poki-iOS
//
//  Created by Insu on 10/14/23.
//

import UIKit

struct Constants {

    // MARK: - Custom Color

    static let d9GrayColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)

    // MARK: - Custom Font

    static let fontRegular = "SUIT-Regular"
    static let fontBold = "SUIT-Bold"
    static let fontExtraLight = "SUIT-ExtraLight"
    static let fontHeavy = "SUIT-Heavy"
    static let fontLight = "SUIT-Light"
    static let fontMedium = "SUIT-Medium"
    static let fontSemiBold = "SUIT-SemiBold"
    static let fontThin = "SUIT-Thin"
    static let fontExtraBold = "SUIT-ExtraBold"

    // MARK: - Login and SignUp

    /// 영대/소문자와 숫자 1자리 + @ + 영대/소문자와 숫자 1자리 + . + 영대/소문자의 조합 2자리 ~ 64자리를 포함하는 이메일을 사용할 수 있습니다.
    static let emailRegex = "[A-Z0-9a-z]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    /// 영대/소문자 1개, 숫자 1개, 특수문자 1개를 포함한 8 ~ 16 자리 비밀번호를 사용할 수 있습니다.
    static let passwordRegex = "(?=.*[a-zA-Z])(?=.*\\d)(?=.*[$@$!%*?&#^().,])[A-Za-z\\d$@$!%*?&#^().,]{8,16}"
    static let nicknameRegex = "[가-힣A-Za-z0-9]{2,8}"
}
