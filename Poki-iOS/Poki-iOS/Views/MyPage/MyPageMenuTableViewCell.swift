//
//  CustomTableViewCell.swift
//  Poki-iOS
//
//  Created by Insu on 10/18/23.
//

import UIKit
import SnapKit
import Then

final class MyPageMenuTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    let cellButton = UIButton(type: .custom).then {
        $0.setTitleColor(.black, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var cellTextLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: Constants.fontMedium, size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var appVersionLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: Constants.fontMedium, size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureCell() {
        contentView.addSubviews(cellButton, cellTextLabel, appVersionLabel)

        cellButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView).offset(-16)
            $0.centerY.equalTo(contentView)
        }

        cellTextLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(16)
            $0.centerY.equalTo(contentView)
        }

        appVersionLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(16)
            $0.centerY.equalTo(contentView)
        }
    }
}
