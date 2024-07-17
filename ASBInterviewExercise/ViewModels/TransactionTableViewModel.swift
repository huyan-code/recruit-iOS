//
//  TransactionTableViewModel.swift
//  ASBInterviewExercise
//
//  Created by yanhu on 17/07/24.
//

import Foundation

class TransactionTableViewModel {
    
    // define the state of the http request
    enum RequestState {
        case idle
        case loading
        case success
        case failure(String)
    }
    
    // the service provides the implementation of requesting transactions
    private let transactionService: TransactionService
    
    // the request result will be available with state change
    var transactions: [Transaction] = []
    
    // the state of the http request
    var state: RequestState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.stateDidChange?(self.state)
            }
        }
    }
    
    // callback to inform others my state
    var stateDidChange: ((RequestState) -> Void)?
    
    // init
    init(transactionService: TransactionService) {
        self.transactionService = transactionService
    }
    
    // call to fetch transactions, the result will be available with state change
    func fetchTransactions() {
        state = .loading
        transactionService.fetchTransactions { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let transactions):
                self.transactions = transactions.sorted(by: { $0.date > $1.date })
                self.state = .success
            case .failure(let error):
                self.state = .failure(error.localizedDescription)
            }
        }
    }
}
