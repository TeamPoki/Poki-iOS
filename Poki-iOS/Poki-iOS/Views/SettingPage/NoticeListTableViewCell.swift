//
//  NoticeListTableViewCell.swift
//  Poki-iOS
//
//  Created by Insu on 10/20/23.
//

import UIKit
import SnapKit
import Then

class NoticeListTableViewCell: UITableViewCell {

    // MARK: - Properties
    let titleLabel = UILabel().then {
        $0.font = UIFont(name: Constants.font, size: 14)
        $0.numberOfLines = 2 // 최대 2줄 표시
    }
    
    let dateLabel = UILabel().then {
        $0.font = UIFont(name: Constants.font, size: 10)
        $0.textColor = .gray
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Helpers
    
}
