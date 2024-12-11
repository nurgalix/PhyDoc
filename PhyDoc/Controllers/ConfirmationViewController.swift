import UIKit

class ConfirmationViewController: UIViewController {
    
    var recordData: RecordData?
    
    // MARK: - UI Elements
    
    private let progressStackView = UIStackView()
    private let titleLabel = UILabel()
    private let warningLabel = UILabel()
    private let detailStackView = UIStackView()
    private let backButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let warningButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupProgressBar()
        
        titleLabel.text = "Подтвердите запись"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressStackView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        let warningStackView = UIStackView()
        warningStackView.axis = .vertical
        warningStackView.spacing = 16
        warningStackView.alignment = .leading
        warningStackView.distribution = .fill
        warningStackView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
        warningStackView.layer.cornerRadius = 12
        warningStackView.isLayoutMarginsRelativeArrangement = true
        warningStackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        view.addSubview(warningStackView)
        warningStackView.addArrangedSubview(warningLabel)
        warningStackView.addArrangedSubview(warningButton)
        
        warningLabel.text = "Отмена и изменение времени приема может стоить денег."
        warningLabel.font = UIFont.systemFont(ofSize: 16)
        warningLabel.textColor = .black
        warningLabel.numberOfLines = 0
        
        warningButton.setTitle("Подробнее", for: .normal)
        warningButton.backgroundColor = .white
        warningButton.setTitleColor(UIColor.brown, for: .normal)
        warningButton.layer.cornerRadius = 20
        warningButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        warningButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        warningButton.addTarget(self, action: #selector(warningButtonTapped), for: .touchUpInside)
        
        
        warningStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(100)
        }
        
        detailStackView.axis = .vertical
        detailStackView.spacing = 16
        view.addSubview(detailStackView)
        detailStackView.snp.makeConstraints { make in
            make.top.equalTo(warningStackView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // Bottom Buttons
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
            stepView.backgroundColor = i < 3 ? .systemBlue : .lightGray
            stepView.layer.cornerRadius = 3
            progressStackView.addArrangedSubview(stepView)
        }
    }
    
    private func populateData() {
        guard let recordData = recordData else { return }
        
        let details = [
            "Формат приема: \(recordData.format ?? "N/A")",
            "Пациент: \(recordData.name ?? "N/A")",
            "Дата: \(recordData.selectedDate ?? "N/A")",
            "Время: \(recordData.selectedTime ?? "N/A")",
            "Цена: \(recordData.selectedCost ?? "N/A")"
        ]
        
        for detail in details {
            let label = UILabel()
            label.text = detail
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .black
            detailStackView.addArrangedSubview(label)
        }
    }
    
    @objc private func warningButtonTapped() {
        print("Подробнее")
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonTapped() {
        print("Appointment confirmed!")
        let successVC = SuccessViewController()
        navigationController?.pushViewController(successVC, animated: true)
    }
}
