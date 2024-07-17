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
    // a pointer to the navi bar item 'reload'
    weak var barBtnItmReload: UIBarButtonItem?

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
                    // pass viewModel to TableView
                    self?.transactionTableView.viewModel = self?.transactionTableViewModel
                    self?.barBtnItmReload?.isEnabled = true
                case .loading:
                    self?.barBtnItmReload?.isEnabled = false
                case .failure, .idle:
                    self?.barBtnItmReload?.isEnabled = true
                    self?.updateStatusView(for: state)

                }
                self?.updateStatusView(for: state)
            }
        }
        
        // response to did select row of the transaction table
        transactionTableView.didSelectTransaction = { [weak self] transaction in
            self?.pushTransactionDetailVC(transaction: transaction)
        }
        
        // start the http request for the transactions
        transactionTableViewModel.fetchTransactions()
        
        // be able to reload on tap, after network errors
        networkStatusView.onReloadingRequest = { [weak self] in
            self?.transactionTableViewModel.fetchTransactions()
        }
        
        // setup the navigation bar item
        setupNavigationBar()
    }

    // setup the transaction table
    func setupTransactionTableView() {
        view.addSubview(transactionTableView)
        transactionTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

// manage navigation bar buttons
extension RootViewController {
    // setup navigation bar with Reload button
    func setupNavigationBar() {
        let itm = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(onTapNaviBarReload))
        navigationItem.rightBarButtonItem = itm
        self.barBtnItmReload = itm
    }
    
    @objc func onTapNaviBarReload() {
        transactionTableViewModel.fetchTransactions()
    }
}

// push the transaction detail view controller
extension RootViewController {
    func pushTransactionDetailVC(transaction:Transaction) {
        let detailVC = TransactionDetailViewController(transaction: transaction)
        self.navigationController?.pushViewController(detailVC, animated: true)
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

