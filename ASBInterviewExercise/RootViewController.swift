//
//  RootViewController.swift
//  ASBInterviewExercise
//
//  Created by ASB on 29/07/21.
//

import UIKit
import SnapKit

class RootViewController: UIViewController {
    // the table view that displays all transactions
    let transactionTableView = TransactionTableView()
    // the network indicator: "Fetching Data..."
    let networkStatusView = FetchingStatusView()
    // the view model for the table view of transactions
    var transactionTableViewModel: TransactionTableViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // resolve the TransactionTableViewModel
        if let viewModel: TransactionTableViewModel = DIManager.shared.resolve(TransactionTableViewModel.self) {
            self.transactionTableViewModel = viewModel
        } else {
            fatalError("Failed to resolve TransactionService.")
        }
        
        title = "Transactions"
        setupTransactionTableView()
        setupStatusView()
                
        // observe transactionTableViewModel's request state
        transactionTableViewModel.stateDidChange = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .success:
                    self?.transactionTableView.viewModel = self?.transactionTableViewModel
                    self?.updateStatusView(for: state)
                default:
                    self?.updateStatusView(for: state)
                }
            }
        }
        
        // response to did select row of the transaction table
        transactionTableView.didSelectTransaction = { [weak self] transaction in
            // todo: launch the detail vc
        }
        
        // start the http request for the transactions
        transactionTableViewModel.fetchTransactions()
    }

    // setup the transaction table
    func setupTransactionTableView() {
        view.addSubview(transactionTableView)
        transactionTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

// manage the state of the "Fetching Data..." status view
extension RootViewController {
    
    func setupStatusView() {
        view.addSubview(networkStatusView)
        networkStatusView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(100)
        }
    }

    func updateStatusView(for state: TransactionTableViewModel.RequestState) {
        switch state {
        case .idle:
            networkStatusView.status = .success
        case .loading:
            networkStatusView.status = .fetching
        case .success:
            networkStatusView.status = .success
        case .failure(let errorMessage):
            networkStatusView.status = .failure(errorMessage)
        }
    }
    
}

