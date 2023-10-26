//
//  Constants.swift
//  Poki-iOS
//
//  Created by Insu on 10/14/23.
//

import UIKit

struct Constants {
    static let d9GrayColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
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
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let passwordRegex = "(?=.*[a-zA-Z])(?=.*\\d)(?=.*[$@$!%*?&#^().,])[A-Za-z\\d$@$!%*?&#^().,]{8,16}"
}
