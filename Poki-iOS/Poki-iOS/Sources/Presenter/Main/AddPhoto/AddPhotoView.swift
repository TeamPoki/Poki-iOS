//
//  AddPhotoView.swift
//  Poki-iOS
//
//  Created by 천광조 on 10/16/23.
//

import UIKit
import SnapKit
import Then

final class AddPhotoView: UIView {
    
    // MARK: - Properties
    
    let photoImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .red
    }
    
    lazy var imageBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.black
        $0.layer.masksToBounds = true
        $0.addSubview(photoImageView)
    }
    
    let dateLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontSemiBold, size: 15)
        $0.textColor = .black
        $0.text = "날짜"
    }
    
    let dateTextField = UITextField().then {
        $0.textColor = .gray
        $0.backgroundColor = Constants.textFieldBackgroundColor
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.clearsOnBeginEditing = false
        $0.placeholder = "날짜를 선택해 주세요"
        $0.layer.cornerRadius = 7
        $0.tintColor = .clear
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.leftViewMode = .always
    }
    
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .inline
        $0.backgroundColor = .systemGray6
        $0.tintColor = .black
        $0.sizeToFit()
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    lazy var dateStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .fill
        $0.spacing = 5
        $0.addArrangedSubviews(dateLabel, dateTextField)
    }
    
    let memoLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "한 줄 메모"
        $0.font = UIFont(name: Constants.fontSemiBold, size: 15)
    }
    
    let memoTextField = UITextField().then {
        $0.textColor = .gray
        $0.backgroundColor = Constants.textFieldBackgroundColor
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.clearsOnBeginEditing = false
        $0.placeholder = "메모를 입력해 주세요"
        $0.layer.cornerRadius = 7
        $0.tintColor = .lightGray
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.leftViewMode = .always
    }
    
    lazy var memoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 5
        $0.addArrangedSubviews(memoLabel, memoTextField)
    }
    
    let tagLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "태그"
        $0.font = UIFont(name: Constants.fontSemiBold, size: 15)
    }
    
    let tagImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.image = UIImage(named: "addButton")
    }
    
    let tagAddButton = UIButton(type: .custom).then {
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .clear
        $0.imageView?.contentMode = .scaleAspectFit
        $0.setTitle("", for: .normal)
    }
    
    lazy var imageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(tagImageView, tagAddButton)
    }
    
    lazy var tagStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(tagLabel, imageStackView)
    }
    
    let addButton = UIButton(type: .custom).then {
        $0.backgroundColor = .black
        $0.setTitle("추가하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        $0.layer.cornerRadius = 25
    }
    
    // MARK: - Helpers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
        layoutSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    private func setup() {
        [imageBackgroundView, dateStackView, memoStackView, tagStackView, addButton].forEach { addSubview($0) }
        dateTextField.inputView = datePicker
    }
    
    private func layoutSetup() {
        dateTextField.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        memoTextField.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        imageBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(dateStackView.snp.top).offset(-20)
        }
        
        photoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(80)
            $0.bottom.equalToSuperview()
        }
        
        tagImageView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
        
        dateStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(65)
        }
        
        memoStackView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(65)
        }
        
        imageStackView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(memoStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(65)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).offset(80)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
    
    func setTagStackViewBorder(show: Bool) {
        if show {
            imageStackView.layer.borderWidth = 0.5
            imageStackView.layer.borderColor = Constants.separatorGrayColor.cgColor
            imageStackView.layer.cornerRadius = imageStackView.frame.height / 2
            imageStackView.layer.shadowOffset = CGSize(width: 0, height: 2)
            imageStackView.layer.shadowRadius = 2
            imageStackView.layer.shadowColor = UIColor.black.cgColor
            imageStackView.layer.shadowOpacity = 0.2
            imageStackView.isLayoutMarginsRelativeArrangement = true
            imageStackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            
        } else {
            imageStackView.layer.borderWidth = 0
            imageStackView.layer.cornerRadius = 0
            imageStackView.layer.shadowOffset = .zero
            imageStackView.layer.shadowRadius = 0
            imageStackView.layer.shadowColor = nil
            imageStackView.layer.shadowOpacity = 0
            imageStackView.isLayoutMarginsRelativeArrangement = false
            imageStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
