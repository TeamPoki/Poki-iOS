//
//  TagCollectionViewCell.swift
//  Poki-iOS
//
//  Created by 천광조 on 10/17/23.
//

import UIKit
import SnapKit
import Then

final class TagCell: UICollectionViewCell {
    
    let tagLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    let tagImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemBackground
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        [tagImageView, tagLabel].forEach{ contentView.addSubview($0) }
        self.layer.cornerRadius = 7
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray4.cgColor
        tagImageView.layer.cornerRadius = tagImageView.frame.size.height / 2
        
        tagImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
        
        
        tagLabel.snp.makeConstraints {
            $0.centerX.equalTo(tagImageView)
            $0.centerY.equalToSuperview().offset(30)
        }
    }
    
    
}
