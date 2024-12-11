//
//  FormatSelectionViewController.swift
//  PhyDoc
//
//  Created by Nurgali on 09.12.2024.
//

import UIKit
import SnapKit

class FormatSelectionViewController: UIViewController {
    
    // MARK: - UI
    
    private let progressStackView = UIStackView()
    private var progressSteps: [UIView] = []
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private var selectedOption: String?
    private var currentStep = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupProgressBar()
        setupTitleLabel()
        setupOptions()
        setupNavigationButtons()
    }
    
    private func setupProgressBar() {
        progressStackView.axis = .horizontal
        progressStackView.distribution = .fillEqually
        progressStackView.spacing = 8
        
        view.addSubview(progressStackView)
        progressStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(6)
        }
        
        for _ in 0..<3 {
            let stepView = UIView()
            stepView.backgroundColor = .lightGray
            stepView.layer.cornerRadius = 3
            progressSteps.append(stepView)
            progressStackView.addArrangedSubview(stepView)
        }
        
        updateProgressBar()
    }
    
    private func updateProgressBar() {
        for (index, step) in progressSteps.enumerated() {
            step.backgroundColor = index < currentStep ? .systemBlue : .lightGray
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Выберите формат приема"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressStackView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func setupOptions() {
        let optionsStackView = UIStackView()
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 16
        optionsStackView.alignment = .fill
        optionsStackView.distribution = .fillEqually
        
        view.addSubview(optionsStackView)
        optionsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        let options = [
            ("Онлайн-консультация", "Врач созвонится с вами и проведет консультацию в приложении."),
            ("Записаться в клинику", "Врач будет ждать вас в своем кабинете в клинике."),
            ("Вызвать на дом", "Врач сам приедет к вам домой в указанное время и дату.")
        ]
        
        for (title, subtitle) in options {
            let button = createOptionButton(title: title, subtitle: subtitle)
            optionsStackView.addArrangedSubview(button)
        }
    }
    
    private func createOptionButton(title: String, subtitle: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.isUserInteractionEnabled = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.isUserInteractionEnabled = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.isUserInteractionEnabled = false
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        button.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func optionButtonTapped(_ sender: UIButton) {
        // Deselect all buttons
        for case let button as UIButton in sender.superview?.subviews ?? [] {
            button.backgroundColor = UIColor(white: 0.95, alpha: 1)
            button.layer.borderColor = UIColor.clear.cgColor
        }
        
        sender.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
        sender.layer.borderColor = UIColor.systemPurple.cgColor
        
        if let stackView = sender.subviews.first as? UIStackView,
           let titleLabel = stackView.arrangedSubviews.first as? UILabel {
            selectedOption = titleLabel.text
        }
        
        print("Selected option: \(selectedOption ?? "None")")
    }
    
    
    private func setupNavigationButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fill
        
        backButton.setTitle("← Назад", for: .normal)
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 20
        backButton.tintColor = .black
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = UIColor.gray.cgColor
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        nextButton.setTitle("Дальше", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 20
        nextButton.tintColor = .white
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        nextButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(nextButton)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        backButton.snp.makeConstraints { make in
            make.width.equalTo(nextButton).multipliedBy(0.8)
        }
    }
    
    
    @objc private func nextButtonTapped() {
        print("Next button tapped. Selected option: \(selectedOption ?? "None")")
        if selectedOption != nil {
            let recordVC = RecordViewController()
            recordVC.recordData = RecordData(format: selectedOption)
            navigationController?.pushViewController(recordVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Выберите формат приема", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
