//
//  TransactionTableView.swift
//  ASBInterviewExercise
//
//  Created by yanhu on 17/07/24.
//

import UIKit

// the table view to display transactions
class TransactionTableView: UIView {
    private let tableView = UITableView()
    private let tableCellId = "TransactionTableCell"
    var isInteractionEnabled = true

    // the view model
    var viewModel: TransactionTableViewModel? {
        didSet {
            reloadData()
        }
    }
    
    // the callback when tapping a cell
    var didSelectTransaction: ((Transaction) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.register(TransactionTableCell.self, forCellReuseIdentifier: tableCellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// manage table view delegate and datasource methods
extension TransactionTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.transactions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath)
        if let transaction = viewModel?.transactions[indexPath.row], let transactionCell = cell as? TransactionTableCell {
            
            let color = transaction.isDebit ? UIColor.red : UIColor.green
            let iconStr = transaction.isDebit ? "icon-debit" : "icon-credit"
            
            transactionCell.configure(summary: transaction.summary, date: transaction.date.description, amount: "\(transaction.amount)", isCredit: !transaction.isDebit)

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard isInteractionEnabled else { return }
        isInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isInteractionEnabled = true
        }
        
        guard let transaction = viewModel?.transactions[indexPath.row] else { return }
        didSelectTransaction?(transaction)
    }
    
}
