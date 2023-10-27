//
//  NoticeListTableViewCell.swift
//  Poki-iOS
//
//  Created by Insu on 10/20/23.
//

import UIKit
import SnapKit
import Then

final class NoticeListCell: UITableViewCell {

    // MARK: - Properties
    
    private lazy var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .hangulWordPriority
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }

    private lazy var dateLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: Constants.fontRegular, size: 12)
        $0.textColor = .lightGray
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15
        $0.distribution = .fill
    }

    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureCell() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(titleLabel, dateLabel)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configure(title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }
}
