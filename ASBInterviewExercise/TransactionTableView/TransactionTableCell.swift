//
//  TransactionTableCell.swift
//  ASBInterviewExercise
//
//  Created by yanhu on 17/07/24.
//

import UIKit
import SnapKit

class TransactionTableCell: UITableViewCell {
    
    // MARK: - Properties
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupConstraints()
        setupAccessibility()
        accessoryType = .disclosureIndicator // Add disclosure indicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupSubviews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 16.0
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(padding)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(24)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-padding)
            make.centerY.equalTo(contentView)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(padding)
            make.leading.equalTo(iconImageView.snp.trailing).offset(padding)
            make.trailing.equalTo(amountLabel.snp.leading).offset(-padding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(4)
            make.leading.equalTo(summaryLabel)
            make.trailing.equalTo(summaryLabel)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-padding)
        }
    }
    
    // MARK: - Configure Cell
    func configure(summary: String, date: String, amount: String, isCredit: Bool) {
        summaryLabel.text = summary
        dateLabel.text = date
        amountLabel.text = amount
        
        if isCredit {
            iconImageView.image = UIImage(named: "icon-credit")
            amountLabel.textColor = .green
        } else {
            iconImageView.image = UIImage(named: "icon-debit")
            amountLabel.textColor = .red
        }
        
        // Set accessibility label for the entire cell
        let creditDebitText = isCredit ? "Credit" : "Debit"
        self.accessibilityLabel = "\(summary), \(date), \(creditDebitText) amount \(amount)"
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        summaryLabel.isAccessibilityElement = true
        summaryLabel.accessibilityLabel = "Summary"
        
        dateLabel.isAccessibilityElement = true
        dateLabel.accessibilityLabel = "Date"
        
        amountLabel.isAccessibilityElement = true
        amountLabel.accessibilityLabel = "Amount"
        
        iconImageView.isAccessibilityElement = true
        iconImageView.accessibilityLabel = "Transaction type"
        
        self.isAccessibilityElement = true
    }
}
