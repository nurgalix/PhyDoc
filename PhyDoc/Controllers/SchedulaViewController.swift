import UIKit

class ScheduleViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let progressStackView = UIStackView()
    private let titleLabel = UILabel()
    private let warningView = UIView()
    private let warningLabel = UILabel()
    private let warningButton = UIButton(type: .system)
    private let collectionView: UICollectionView
    private let backButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    private var schedule: [DaySchedule] = [] // Your existing DaySchedule model
    private var selectedSlot: Slot?
    private var selectedIndexPath: IndexPath?
    
    var recordData: RecordData?
    
    // MARK: - Initialization
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 80, height: 50)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchSchedule()
    }
    
    // MARK: - Networking
    
    private func fetchSchedule() {
        guard let url = URL(string: "https://phydoc-test-2d45590c9688.herokuapp.com/get_schedule?type=online") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            do {
                let decodedData = try JSONDecoder().decode([String: [Slot]].self, from: data)
                guard let slots = decodedData["slots"] else { return }
                
                var groupedSlots: [String: [Slot]] = [:]
                for slot in slots {
                    let dateTimeComponents = slot.datetime.split(separator: "T")
                    guard dateTimeComponents.count == 2 else { continue }
                    let date = String(dateTimeComponents[0])
                    groupedSlots[date, default: []].append(slot)
                }
                
                self.schedule = groupedSlots.map { DaySchedule(date: $0.key, slots: $0.value) }
                    .sorted { $0.date < $1.date }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        task.resume()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupProgressBar()
        
        titleLabel.text = "Выберите дату и время"
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
        
        // Collection View
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SlotCell.self, forCellWithReuseIdentifier: "SlotCell")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(warningStackView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
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
        nextButton.isEnabled = false
        
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
    
    // MARK: - Actions
    
    @objc private func warningButtonTapped() {
        print("Warning button tapped!")
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonTapped() {
        guard let selectedSlot = selectedSlot else { return }
        print("Selected slot: \(selectedSlot)")
        
        // Update RecordData with selected schedule details
        recordData?.selectedDate = selectedSlot.datetime.split(separator: "T")[0].description // Extract date
        recordData?.selectedTime = selectedSlot.datetime.split(separator: "T")[1].prefix(5).description // Extract time
        recordData?.selectedCost = "\(selectedSlot.price)₸"
        recordData?.slotId = selectedSlot.id 
        
        let confirmationVC = ConfirmationViewController()
        confirmationVC.recordData = recordData
        navigationController?.pushViewController(confirmationVC, animated: true)
    }
}

// MARK: - Collection View Data Source and Delegate

extension ScheduleViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return schedule.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedule[section].slots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotCell", for: indexPath) as? SlotCell else {
            return UICollectionViewCell()
        }
        let slot = schedule[indexPath.section].slots[indexPath.row]
        cell.configure(with: slot)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let previousIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: previousIndexPath) as? SlotCell {
            previousCell.setSelected(false)
        }
        
        selectedIndexPath = indexPath
        if let currentCell = collectionView.cellForItem(at: indexPath) as? SlotCell {
            currentCell.setSelected(true)
        }
        
        selectedSlot = schedule[indexPath.section].slots[indexPath.row]
        nextButton.isEnabled = true
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? SectionHeaderView else {
                return UICollectionReusableView()
            }
            
            let date = schedule[indexPath.section].date
            headerView.configure(with: date)
            return headerView
        }
        
        return UICollectionReusableView()
    }
}

