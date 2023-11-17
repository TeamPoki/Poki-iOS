//
//  Constants.swift
//  Poki-iOS
//
//  Created by Insu on 10/14/23.
//

import UIKit

struct Constants {

    // MARK: - Custom Color

    static let appBlackColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)
    static let separatorGrayColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
    static let textFieldBackgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)

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

    /// 영대소문자, 숫자, 특수문자(._-) 1자리 + @ + 영대소문자, 숫자, 특수문자(._-) 1자리 + . + 영대/소문자의 조합 2자리 ~ 64자리를 포함하는 이메일을 사용할 수 있습니다.
    static let emailRegex = "[A-Z0-9a-z._-]+@[A-Za-z0-9._-]+\\.[A-Za-z]{2,64}"
    /// 영대/소문자 1개, 숫자 1개, 특수문자 1개를 포함한 8 ~ 20 자리 비밀번호를 사용할 수 있습니다.
    static let passwordRegex = "(?=.*[a-zA-Z])(?=.*\\d)(?=.*[$@$!%*?&#^().,])[A-Za-z\\d$@$!%*?&#^().,]{8,20}"
    /// 한글, 영대소문자, 숫자, 특수문자(._-) 중 2~8 자리를 사용할 수 있습니다.
    static let nicknameRegex = "[가-힣A-Za-z0-9._-]{2,8}"
}
