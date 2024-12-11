//
//  RecordViewController.swift
//  PhyDoc
//
//  Created by Nurgali on 10.12.2024.
//

import UIKit

class RecordViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let progressStackView = UIStackView()
    private let titleLabel = UILabel()
    private let segmentedControl = UISegmentedControl(items: ["Себя", "Другого"])
    private let fieldsStackView = UIStackView()
    private let backButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    var recordData: RecordData?
    
    // "Себя"
    private let nameLabel = UILabel()
    private let nameValueLabel = UILabel()
    private let iinLabel = UILabel()
    private let iinValueLabel = UILabel()
    private let phoneLabel = UILabel()
    private let phoneValueLabel = UILabel()
    private let addressLabel = UILabel()
    private let addressValueLabel = UILabel()
    
    // "Другого"
    private let nameTLabel = UILabel()
    private let nameTextField = UITextField()
    private let iinTLabel = UILabel()
    private let iinTextField = UITextField()
    private let phoneTLabel = UILabel()
    private let phoneTextField = UITextField()
    private let addressTLabel = UILabel()
    private let addressTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showSelfMode() // Default to "Себя"
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupProgressBar()
        
        titleLabel.text = "Выберите кого хотите записать"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressStackView.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(16)
        }
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        fieldsStackView.axis = .vertical
        fieldsStackView.spacing = 16
        fieldsStackView.alignment = .fill
        fieldsStackView.distribution = .fill
        view.addSubview(fieldsStackView)
        fieldsStackView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        setupStaticLabels()
        setupTextFields()
        
        setupBottomButtons()
    }
    
    private func setupProgressBar() {
        progressStackView.axis = .horizontal
        progressStackView.distribution = .fillEqually
        progressStackView.spacing = 8
        
        view.addSubview(progressStackView)
        progressStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(8)
            make.width.equalTo(120)
            make.centerX.equalToSuperview()
            make.height.equalTo(6)
        }
        
        for i in 0..<3 {
            let stepView = UIView()
            stepView.backgroundColor = i < 2 ? .systemBlue : .lightGray
            stepView.layer.cornerRadius = 3
            progressStackView.addArrangedSubview(stepView)
        }
    }
    
    private func setupStaticLabels() {
        
        setupLabel(nameLabel, text: "Имя и фамилия:")
        setupBoldLabel(nameValueLabel, text: "Иванов Иван")
        
        setupLabel(iinLabel, text: "ИИН:")
        setupBoldLabel(iinValueLabel, text: "041115486195")
        
        setupLabel(phoneLabel, text: "Номер телефона:")
        setupBoldLabel(phoneValueLabel, text: "+7 707 748 4815")
        
        setupLabel(addressLabel, text: "Адрес прописки:")
        setupBoldLabel(addressValueLabel, text: "ул. Гани Иляева 15")
        
        [nameLabel, nameValueLabel, iinLabel, iinValueLabel, phoneLabel, phoneValueLabel, addressLabel, addressValueLabel].forEach {
            fieldsStackView.addArrangedSubview($0)
        }
    }
    
    private func setupTextFields() {
        setupLabel(nameTLabel, text: "Имя и фамилия:")
        setupTextField(nameTextField, placeholder: "Иван Иванов")
        setupLabel(iinTLabel, text: "ИИН:")
        setupTextField(iinTextField, placeholder: "Введите ИИН человека")
        setupLabel(phoneTLabel, text: "Номер телефона")
        setupTextField(phoneTextField, placeholder: "Введите номер телефона")
        setupLabel(addressTLabel, text: "Адрес")
        setupTextField(addressTextField, placeholder: "Адрес прописки")
        
        [nameTLabel, nameTextField, iinTLabel, iinTextField, phoneTLabel, phoneTextField, addressTLabel,  addressTextField].forEach {
            $0.isHidden = true
            fieldsStackView.addArrangedSubview($0)
        }
    }
    
    private func setupBottomButtons() {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fill
        
        // Back Button
        backButton.setTitle("← Назад", for: .normal)
        backButton.backgroundColor = .white
        backButton.setTitleColor(.black, for: .normal)
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = UIColor.gray.cgColor
        backButton.layer.cornerRadius = 20
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Next Button
        nextButton.setTitle("Дальше", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 20
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nextButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(backButton)
        buttonStackView.addArrangedSubview(nextButton)
        view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        backButton.snp.makeConstraints { make in
            make.width.equalTo(nextButton).multipliedBy(0.8)
        }
    }
    
    private func setupLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
    }
    
    private func setupBoldLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        //        textField.isHidden = true
    }
    
    // MARK: - Actions
    
    @objc private func segmentChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            showSelfMode()
        } else {
            showOtherMode()
        }
    }
    
    private func showSelfMode() {
        [nameLabel, nameValueLabel, iinLabel, iinValueLabel, phoneLabel, phoneValueLabel, addressLabel, addressValueLabel].forEach {
            $0.isHidden = false
        }
        [nameTLabel, nameTextField, iinTLabel, iinTextField, phoneTLabel, phoneTextField, addressTLabel, addressTextField].forEach {
            $0.isHidden = true
        }
    }
    
    private func showOtherMode() {
        [nameLabel, nameValueLabel, iinLabel, iinValueLabel, phoneLabel, phoneValueLabel, addressLabel, addressValueLabel].forEach {
            $0.isHidden = true
        }
        [nameTLabel, nameTextField, iinTLabel, iinTextField, phoneTLabel, phoneTextField, addressTLabel, addressTextField].forEach {
            $0.isHidden = false
        }
    }
    
    @objc private func backButtonTapped() {
        print("Back button tapped!")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonTapped() {
        print("Next button tapped!")
        
        if segmentedControl.selectedSegmentIndex == 0 {
            recordData?.name = nameValueLabel.text
            recordData?.iin = iinValueLabel.text
            recordData?.phone = phoneValueLabel.text
            recordData?.address = addressValueLabel.text
        } else {
            recordData?.name = nameTextField.text
            recordData?.iin = iinTextField.text
            recordData?.phone = phoneTextField.text
            recordData?.address = addressTextField.text
        }
        
        let scheduleVC = ScheduleViewController()
        scheduleVC.recordData = recordData
        navigationController?.pushViewController(scheduleVC, animated: true)
        
    }
}
