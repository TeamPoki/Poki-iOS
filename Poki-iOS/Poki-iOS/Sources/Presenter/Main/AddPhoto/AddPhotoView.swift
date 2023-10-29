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
        $0.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        $0.borderStyle = .roundedRect
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.clearsOnBeginEditing = false
        $0.placeholder = "날짜를 선택해 주세요"
        $0.layer.cornerRadius = 7
    }
    
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .inline
        $0.sizeToFit()
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    lazy var dateStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution  = .fillProportionally
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
        $0.distribution  = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(tagImageView, tagAddButton)
    }
    
    lazy var tagStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution  = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 10
        $0.addArrangedSubviews(tagLabel, imageStackView)
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
            $0.leading.trailing.equalToSuperview().inset(100)
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
            $0.top.equalTo(dateStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(65)
        }
        
        imageStackView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(memoStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(65)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).offset(80)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo(40)
        }
    }
    
    //datePicker done 버튼
//    private func creatToolBar() -> UIToolbar {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
//        toolbar.setItems([doneButton], animated: true)
//        
//        return toolbar
//    }
//    
//    @objc private func donePressed() {
//        let formmater = DateFormatter()
//        formmater.dateFormat = "yyyy년 MM월 dd일"
//        formmater.locale = Locale(identifier: "ko_KR")
//        //데이터를 넣을 곳
//        self.dateTextField.text = formmater.string(from: datePicker.date)
//        self.endEditing(true)
//    }
    
}


