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
        $0.font = UIFont(name: Constants.fontBold, size: 24)
    }
    
    var dateLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
    }
    
    var separatorLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "•"
    }
    
    var tagLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
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
        addSubviews(photoImage, titleLabel, dateLabel, separatorLabel, tagLabel)
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
        
        separatorLabel.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(dateLabel)
        }
        
        tagLabel.snp.makeConstraints {
            $0.leading.equalTo(separatorLabel.snp.trailing).offset(5)
            $0.trailing.lessThanOrEqualToSuperview().offset(-15)
            $0.centerY.equalTo(dateLabel)
        }
    }
    
    func applyGradient(with color: UIColor) {
        let adjustedColor = color.withAlphaComponent(1.5)
        
        // 기존 그라데이션 제거 -> 새로운 사진이 추가될때 마다 그라데이션도 같이 추가되는 방식이라 그라데이션 겹침 방지
        if let existingGradient = self.photoImage.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            existingGradient.removeFromSuperlayer()
        }
        
        // 새로운 그라데이션 추가
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: self.bounds.height - 150, width: self.bounds.width, height: 150)
        gradient.colors = [color.withAlphaComponent(0).cgColor, adjustedColor.cgColor]
        gradient.locations = [0, 1]
        self.photoImage.layer.insertSublayer(gradient, at: 0)
    }

    func setGradient(image: UIImage) {
        self.photoImage.image = image
        if let color = image.dominantColor() {
            applyGradient(with: color)
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let collectionView = superview as? UICollectionView else { return false }
        
        // CarouselFlowLayout 파일 -> sideItemScale 사용
        let layout = collectionView.collectionViewLayout as? CarouselFlowLayout
        let scale = layout?.sideItemScale ?? 1.0

        // 중앙 셀의 너비를 계산
        let centralWidth = bounds.width * scale

        // 셀의 프레임을 상위 뷰의 좌표계로 변환
        let cellFrameInSuperview = collectionView.convert(frame, to: collectionView.superview)
        
        // 중앙 셀 터치 가능 영역 설정
        let centralRect = CGRect(x: cellFrameInSuperview.origin.x + (cellFrameInSuperview.size.width - centralWidth) / 3,
                                 y: cellFrameInSuperview.origin.y,
                                 width: centralWidth,
                                 height: cellFrameInSuperview.size.height)

        // 터치 포인트가 중앙 영역 안에 있는지 확인
        return centralRect.contains(point)
    }
}
