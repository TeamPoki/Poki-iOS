//
//  AddPhotoView.swift
//  Poki-iOS
//
//  Created by 천광조 on 10/16/23.
//

import UIKit

final class AddPhotoView: UIView {
    
    // MARK: - Properties
    
    let photoImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .red
    }
    
    let dateLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .black
        $0.text = "날짜"
    }
    
    let dateButtonTapped = UIButton(type: .custom).then {
        $0.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        $0.setTitle("날짜를 선택해 주세요", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.cornerRadius = 7
        $0.contentHorizontalAlignment = .left
    }
    
    lazy var dateStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution  = .fill
        $0.alignment = .fill
        $0.spacing = 0
        $0.addArrangedSubviews(dateLabel, dateButtonTapped)
    }
    
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .inline
        $0.date = .now
        $0.sizeToFit()
    }
    
    let memoLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .black
        $0.text = "한 줄 메모"
    }
    
    let memoTextField = UITextField().then {
        $0.textColor = .gray
        $0.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        $0.borderStyle = .roundedRect
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.clearsOnBeginEditing = false
        $0.placeholder = "메모를 입력해 주세요"
        $0.layer.cornerRadius = 7
    }
    
    lazy var memoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution  = .fill
        $0.alignment = .fill
        $0.spacing = 0
        $0.addArrangedSubviews(memoLabel, memoTextField)
    }
    
    let tagLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .black
        $0.text = "태그"
    }
    
    let tagButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "addButton"), for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.sizeToFit()
        $0.backgroundColor = .clear
    }
    
    lazy var tagStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution  = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 0
        $0.addArrangedSubviews(tagLabel, tagButton)
    }
    
    let addButton = UIButton(type: .custom).then {
        $0.backgroundColor = .black
        $0.setTitle("작성완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 7
        
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
        [photoImageView, dateStackView, memoStackView, tagStackView, addButton].forEach { addSubview($0) }
    }
    
    private func layoutSetup() {
        dateButtonTapped.snp.makeConstraints {
            $0.height.equalTo(40)
        }
                
        memoTextField.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        tagLabel.snp.makeConstraints {
            $0.height.equalTo(25)
        }

        photoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(120)
            $0.bottom.equalTo(dateStackView.snp.top).offset(-20)
        }
        
        dateStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(65)
        }
        
        memoStackView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(65)
        }
        
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(memoStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).offset(80)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo(40)
        }
    }
    
}
