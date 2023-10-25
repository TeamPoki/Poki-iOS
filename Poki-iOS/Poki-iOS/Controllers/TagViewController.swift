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

class TagViewController: UIViewController {
    // MARK: - Properties
    
    let dataArray = TagData.data
    
    weak var delegate: TagSelectionDelegate?
    
    let dataManager = PoseImageManager.shared
    let stoageManager = StorageManager.shared
    
    let tagTitleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 25)
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
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCollectionViewCell")
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
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(tagTitleLabel).offset(50)
            $0.bottom.equalToSuperview()
        }
    }
    
    
    
    // MARK: - Actions
    

}


extension TagViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell()}
        let data = dataArray[indexPath.row]
        stoageManager.downloadImage(urlString: data.tagImage) {  image in
            DispatchQueue.main.async {
                cell.tagImageView.image = image
            }
        }
        cell.tagLabel.text = data.tagLabel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = dataArray[indexPath.row]
        self.delegate?.didSelectTag(data)
        dismiss(animated: true)
    }
}

extension TagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 3) - 6
        return CGSize(width: width, height: width - 25)
    }
}
