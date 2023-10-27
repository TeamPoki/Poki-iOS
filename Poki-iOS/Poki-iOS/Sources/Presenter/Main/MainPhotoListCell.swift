//
//  PhotoListCollectionViewCell.swift
//  Poki-iOS
//
//  Created by Insu on 10/18/23.
//

import UIKit
import SnapKit
import Then

final class MainPhotoListCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var photoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: Constants.fontExtraBold, size: 32)
    }
    
    var dateLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
    }
    
    var tagImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    var tagLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
        $0.textAlignment = .right
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureCell() {
        addSubviews(photoImage, titleLabel, dateLabel, tagImage, tagLabel)
        self.backgroundColor = UIColor.clear
        
        photoImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-30)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        tagImage.snp.makeConstraints {
            $0.trailing.equalTo(tagLabel.snp.leading).offset(-10)
            $0.centerY.equalTo(tagLabel)
            $0.width.height.equalTo(20)
        }
        
        tagLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(10)
        }
    }
}
