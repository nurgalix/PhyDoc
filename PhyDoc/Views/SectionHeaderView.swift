//
//  SectionHeaderView.swift
//  PhyDoc
//
//  Created by Nurgali on 11.12.2024.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

        private let titleLabel = UILabel()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupUI() {
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.textColor = .gray

            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(8)
            }
        }

        func configure(with title: String) {
            titleLabel.text = title
        }
}
