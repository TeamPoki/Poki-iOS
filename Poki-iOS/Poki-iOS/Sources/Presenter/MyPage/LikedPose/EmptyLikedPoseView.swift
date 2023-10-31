//
//  EmptyLikedPoseView.swift
//  Poki-iOS
//
//  Created by 요시킴 on 2023/10/31.
//

import UIKit
import SnapKit
import Then

class EmptyLikedPoseView: UIView {
    // MARK: - Properties
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if let image = UIImage(named: "star-slash") {
            imageView.image = image
        }
        return imageView
    }()
    
    private let firstLabel = UILabel().then {
        $0.text = "즐겨찾기 한 포즈가 없습니다."
        $0.textColor = .lightGray
        $0.font = UIFont(name: Constants.fontSemiBold, size: 22)
    }
    
    private let secondLabel = UILabel().then {
        $0.text = "포즈 추천에서 마음에 드는 포즈를 골라주세요."
        $0.textColor = .lightGray
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
    }
    
    private let poseRecommendButton = UIButton().then {
        $0.setTitle("포즈 추천 하러가기", for: .normal)
        $0.titleLabel?.font = UIFont(name: Constants.fontRegular, size: 16)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.backgroundColor = .white
        $0.addTarget(EmptyLikedPoseView.self, action: #selector(poseRecommendButtonTapped), for: .touchUpInside)
        
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 25.0
        
        $0.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.addArrangedSubviews(emptyImageView, firstLabel, secondLabel, poseRecommendButton)
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
    
    // MARK: - Actions
    @objc private func poseRecommendButtonTapped() {
        // 포즈 추천 페이지 이동 메서드
    }
}
