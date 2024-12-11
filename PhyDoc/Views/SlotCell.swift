import UIKit

class SlotCell: UICollectionViewCell {
    private let timeLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [timeLabel, priceLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        
        timeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = .gray
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with slot: Slot) {
        timeLabel.text = String(slot.datetime.split(separator: "T")[1].prefix(5)) // HH:mm
        priceLabel.text = "\(slot.price)₸"
    }
    
    func setSelected(_ isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = .systemBlue
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
            timeLabel.textColor = .white
            priceLabel.textColor = .white
        } else {
            contentView.backgroundColor = .white
            contentView.layer.borderColor = UIColor.lightGray.cgColor
            timeLabel.textColor = .black
            priceLabel.textColor = .gray
        }
    }
}
