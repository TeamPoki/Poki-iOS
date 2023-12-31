//
//  TagViewController.swift
//  Poki-iOS
//
//  Created by 천광조 on 10/17/23.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class TagVC: UIViewController {
    
    // MARK: - Properties
    
    let dataArray = TagData.data
    let stoageManager = StorageManager.shared
    weak var delegate: TagSelectionDelegate?
    
    let tagTitleLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontSemiBold, size: 20)
        $0.textColor = .black
        $0.text = "태그 선택"
        $0.backgroundColor = UIColor.systemBackground
        $0.textAlignment = .center
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 2

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "TagCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [tagTitleLabel, collectionView].forEach { self.view.addSubview($0) }
        setup()
        layoutSetup()
    }
    
    // MARK: - Helpers
    
    private func setup() {
        self.title = "태그 선택"
        self.view.backgroundColor = UIColor.systemBackground
    }
    
    private func layoutSetup() {
        tagTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }

        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(tagTitleLabel).offset(50)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TagVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as? TagCell else { return UICollectionViewCell() }
        let data = self.dataArray[indexPath.row]
        let url = URL(string: data.tagImage)
        cell.tagImageView.kf.setImage(with: url)
        cell.tagLabel.text = data.tagLabel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = dataArray[indexPath.row]
        self.delegate?.didSelectTag(data)
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TagVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 3) - 6
        return CGSize(width: width, height: width - 25)
    }
}
