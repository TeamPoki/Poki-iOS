//
//  EmptyPhotoListView.swift
//  Poki-iOS
//
//  Created by 요시킴 on 2023/11/01.
//

import UIKit
import SnapKit
import Then

class EmptyPhotoListView: UIView {
    
    // MARK: - Properties
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "rectangle.portrait.on.rectangle.portrait.slash.fill")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        return imageView
    }()
    
    private let firstLabel = UILabel().then {
        $0.text = "추가한 네컷사진이 없습니다."
        $0.textColor = .lightGray
        $0.font = UIFont(name: Constants.fontSemiBold, size: 24)
    }
    
    private let secondLabel = UILabel().then {
        $0.text = "+ 버튼을 눌러서 사진을 추가해주세요."
        $0.textColor = .lightGray
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.addArrangedSubviews(emptyImageView, firstLabel, secondLabel)
        $0.alignment = .center
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    // MARK: - Helpers
    
    private func setupViews() {
        addSubviews(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
    }
    
}
