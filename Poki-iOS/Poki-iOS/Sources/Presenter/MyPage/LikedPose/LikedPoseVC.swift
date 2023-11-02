//
//  LikedPoseViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/20/23.
//

import UIKit
import SnapKit
import Then

enum PoseCategory: String {
    case alone
    case two
    case many
}

final class LikedPoseVC: UIViewController {
    
    // MARK: - Properties
    let emptyView = EmptyLikedPoseView()
    let firestoreManager = FirestoreManager.shared
    let storageManager = StorageManager.shared
    
    private var photos: [UIImage?] = []
    private var imageDatas:[ImageData] = []
    
    private let barColor = UIView()
    private let contentView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
    private let likedPoseCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var poseOne = UILabel().then {
        $0.text = "한 명 포즈"
        $0.textColor = .black
        $0.font = UIFont(name: Constants.fontRegular, size: 14)
        $0.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(poseOneTapped))
        $0.addGestureRecognizer(tapGesture)
    }
    
    private lazy var poseTwo = UILabel().then {
        $0.text = "두 명 포즈"
        $0.textColor = .black
        $0.font = UIFont(name: Constants.fontRegular, size: 14)
        $0.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(poseTwoTapped))
        $0.addGestureRecognizer(tapGesture)
    }
    
    private lazy var poseThree = UILabel().then {
        $0.text = "여러명 포즈"
        $0.textColor = .black
        $0.font = UIFont(name: Constants.fontRegular, size: 14)
        $0.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(poseManyTapped))
        $0.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        emptyViewButtonTap()
        contentsViewUI()
        likedPoseCollectionViewUI()
        configureNav()
        firestoreManager.poseRealTimebinding { _ in }
        updateCollectionViewForCategory(.alone)
        showBarColorForLabel(poseOne)
    }
    // 데이터의 근원
    // 레이아웃 , 뷰, - 데이터 - 액션
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
        likedPoseCollectionView.reloadData()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "찜 한 포즈"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.configureBasicAppearance()
    }
    
    private func showBarColorForLabel(_ label: UILabel) {
        barColor.removeFromSuperview()
        
        contentView.addSubview(barColor)
        barColor.backgroundColor = UIColor.black
        
        barColor.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(2)
            make.leading.equalTo(label.snp.leading)
            make.trailing.equalTo(label.snp.trailing)
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func contentsViewUI() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(contentView)
        }
        
        stackView.addArrangedSubview(poseOne)
        stackView.addArrangedSubview(poseTwo)
        stackView.addArrangedSubview(poseThree)
        
        poseOne.snp.makeConstraints { make in
            make.height.equalTo(stackView)
        }
        poseTwo.snp.makeConstraints { make in
            make.height.equalTo(stackView)
        }
        poseThree.snp.makeConstraints { make in
            make.height.equalTo(stackView)
        }
        
        poseOne.textAlignment = .center
        poseTwo.textAlignment = .center
        poseThree.textAlignment = .center
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            
        }
    }
    
    private func likedPoseCollectionViewUI() {
        view.addSubview(likedPoseCollectionView)
        likedPoseCollectionView.delegate = self
        likedPoseCollectionView.dataSource = self
        likedPoseCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        likedPoseCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
        }
    }
    
    func updateCollectionViewForCategory(_ category: PoseCategory) {
        self.likedPoseCollectionView.reloadData()
            switch category {
            case .alone:
                if firestoreManager.poseData.filter({ $0.category == "alone" }).filter({ $0.isSelected == true }).count == 0 {
                    emptyView.isHidden = false
                    likedPoseCollectionView.isHidden = true
                } else {
                    self.imageDatas = firestoreManager.poseData.filter { $0.category == "alone" }.filter { $0.isSelected == true }
                    storageManager.poseDownloadImages(fromURLs: imageDatas.map{ $0.imageUrl }) { [weak self] images in
                        guard let self = self else { return}
                        photos = images
                        emptyView.isHidden = true
                        likedPoseCollectionView.isHidden = false
                        likedPoseCollectionView.reloadData()
                    }
                }
               
            case .two:
                if firestoreManager.poseData.filter({ $0.category == "twoPose" }).filter({ $0.isSelected == true }).count == 0 {
                    emptyView.isHidden = false
                    likedPoseCollectionView.isHidden = true
                } else {
                    self.imageDatas = firestoreManager.poseData.filter { $0.category == "twoPose" }.filter { $0.isSelected == true }
                    storageManager.poseDownloadImages(fromURLs: imageDatas.map{ $0.imageUrl }) { [weak self] images in
                        guard let self = self else { return}
                        photos = images
                        emptyView.isHidden = true
                        likedPoseCollectionView.isHidden = false
                        likedPoseCollectionView.reloadData()
                    }
                }
                
            case .many:
                if firestoreManager.poseData.filter({ $0.category == "manyPose" }).filter({ $0.isSelected == true }).count == 0 {
                    emptyView.isHidden = false
                    likedPoseCollectionView.isHidden = true
                } else {
                    self.imageDatas = firestoreManager.poseData.filter { $0.category == "manyPose" }.filter { $0.isSelected == true }
                    storageManager.poseDownloadImages(fromURLs: imageDatas.map{ $0.imageUrl }) { [weak self] images in
                        guard let self = self else { return}
                        photos = images
                        emptyView.isHidden = true
                        likedPoseCollectionView.isHidden = false
                        likedPoseCollectionView.reloadData()
                    }
                }
                
        }
        likedPoseCollectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func poseOneTapped() {
        showBarColorForLabel(poseOne)
        updateCollectionViewForCategory(.alone)
    }
    
    @objc private func poseTwoTapped() {
        showBarColorForLabel(poseTwo)
        updateCollectionViewForCategory(.two)
    }
    
    @objc private func poseManyTapped() {
        showBarColorForLabel(poseThree)
        updateCollectionViewForCategory(.many)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension LikedPoseVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = UIImageView()
        imageView.image = photos[indexPath.item]
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = photos[indexPath.item]
        let detailViewController = LikedPoseImageDetailVC()
        detailViewController.image = selectedImage
        
        let navController = UINavigationController(rootViewController: detailViewController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    private func emptyViewButtonTap() {
        emptyView.poseRecommendButton.addTarget(self, action: #selector(poseRecommendButtonTapped), for: .touchUpInside)
    }
    
    @objc private func poseRecommendButtonTapped() {
        let poseSuggestionVC = PoseSuggestionVC()
        self.navigationController?.pushViewController(poseSuggestionVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LikedPoseVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSpacing: CGFloat = 5
        let leftRightSpacing: CGFloat = 10
        let itemsPerLine: CGFloat = 2
        
        let totalSpacing = (itemsPerLine - 1) * cellSpacing + leftRightSpacing * 2
        let width = (collectionView.bounds.width - totalSpacing) / itemsPerLine
        let height = 280.0
        
        return CGSize(width: width, height: height)
    }
}
