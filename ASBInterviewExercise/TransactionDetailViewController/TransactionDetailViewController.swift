//
//  TransactionDetailViewController.swift
//  ASBInterviewExercise
//
//  Created by yanhu on 17/07/24.
//

import UIKit
import SnapKit

class TransactionDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let transaction: Transaction
    
    // MARK: - UI Components
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 5  // Maximum 5 lines for summary
        label.textAlignment = .center
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let gstRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let gstValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialization
    init(transaction: Transaction) {
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transaction Detail"
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    private func setupSubviews() {
        view.addSubview(iconImageView)
        view.addSubview(idLabel)
        view.addSubview(dateLabel)
        view.addSubview(summaryLabel)
        view.addSubview(amountLabel)
        view.addSubview(gstRateLabel)
        view.addSubview(gstValueLabel)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 20.0
        
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(padding)
            make.width.height.equalTo(50)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        
        gstRateLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
        
        gstValueLabel.snp.makeConstraints { make in
            make.top.equalTo(gstRateLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-padding)
        }
    }
    
    private func configureUI() {
        if transaction.isDebit {
            iconImageView.image = UIImage(named: "icon-debit")
            amountLabel.textColor = .red
        } else {
            iconImageView.image = UIImage(named: "icon-credit")
            amountLabel.textColor = .green
        }
        
        idLabel.text = "Transaction ID: \(transaction.id)"
        dateLabel.text = "Date: \(transaction.date.description)"
        summaryLabel.text = "Summary: \(transaction.summary)"
        
        let gstRate = 15.0
        gstRateLabel.text = "GST Rate: \(gstRate)%"
        gstValueLabel.text = String(format: "GST Value: $%.2f", transaction.gst)
        
        if transaction.isDebit {
            amountLabel.text = String(format: "Debit: $%.2f", transaction.debit)
        } else {
            amountLabel.text = String(format: "Credit: $%.2f", transaction.credit)
        }
    }
}
