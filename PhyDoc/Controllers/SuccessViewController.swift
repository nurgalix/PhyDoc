import UIKit

final class SuccessViewController: UIViewController {
    
    private let successLabel = UILabel()
    private let successButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        setupUI()
    }
    
    private func setupUI() {
        successLabel.text = "Вы записаны на прием"
        successLabel.font = UIFont.boldSystemFont(ofSize: 32)
        successLabel.textAlignment = .center
        successLabel.textColor = .white
        view.addSubview(successLabel)
        
        successLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }
        
        
        successButton.setTitle("Дальше", for: .normal)
        successButton.backgroundColor = .white
        successButton.setTitleColor(.black, for: .normal)
        successButton.layer.cornerRadius = 20
        successButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        successButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        successButton.addTarget(self, action: #selector(successButtonTapped), for: .touchUpInside)
        view.addSubview(successButton)
        
        successButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    @objc private func successButtonTapped() {
        print("Success")
        navigationController?.popToRootViewController(animated: true)
    }
}
