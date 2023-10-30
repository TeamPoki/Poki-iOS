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
    
    lazy var buttonImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
        $0.numberOfLines = 0
        $0.isHidden = true
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
        contentView.addSubviews(stackView, buttonImageView)
        stackView.addArrangedSubviews(titleLabel, dateLabel)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        buttonImageView.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
    }
    
    func configure(notice: NoticeList, isExpanded: Bool) {
        titleLabel.text = notice.title
        dateLabel.text = notice.date
        contentLabel.text = notice.content
        contentLabel.isHidden = !isExpanded
        if isExpanded {
            stackView.addArrangedSubview(contentLabel)
            buttonImageView.image = UIImage(systemName: "chevron.up")
        } else {
            stackView.removeArrangedSubview(contentLabel)
            contentLabel.removeFromSuperview()
            buttonImageView.image = UIImage(systemName: "chevron.down")
        }
    }
}
