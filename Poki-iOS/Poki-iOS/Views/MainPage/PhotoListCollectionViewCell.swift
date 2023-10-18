//
//  PhotoListCollectionViewCell.swift
//  Poki-iOS
//
//  Created by Insu on 10/18/23.
//

import UIKit
import SnapKit
import Then

class PhotoListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var photoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 18)
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
        addSubviews(photoImage, titleLabel)
        self.backgroundColor = UIColor.clear
        
        photoImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
}
