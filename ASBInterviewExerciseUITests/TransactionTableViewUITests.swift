//
//  TransactionTableViewUITests.swift
//  ASBInterviewExerciseUITests
//
//  Created by yanhu on 17/07/24.
//

import XCTest
import Foundation
import UIKit
import SnapKit

// fake TransactionService to bypass the initialization of TransactionTableViewModel
class TransactionService {
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {}
}

final class TransactionTableViewUITests: XCTestCase {

    var transactionTableView: TransactionTableView!

    override func setUpWithError() throws {
        try? super.setUpWithError()
        continueAfterFailure = false
        
        // 1) setup the TransactionTableView
        transactionTableView = TransactionTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        
        // 2) create the view model for the table
        let viewModel = TransactionTableViewModel(transactionService: TransactionService())
        
        // 3) fill with mock data
        viewModel.transactions = [
            Transaction(id: 1001, transactionDate: "2022-02-17T10:44:35", summary: "UI test transaction 1001", debit: 300.0, credit: 0),
            Transaction(id: 1002, transactionDate: "2022-02-17T10:44:35", summary: "UI test transaction 1002", debit: 0, credit: 5000.0)
        ]
        transactionTableView.viewModel = viewModel
        
        // 4) render the table on screen
        UIApplication.shared.windows.first?.rootViewController?.view.addSubview(transactionTableView)
    }

    override func tearDownWithError() throws {
        transactionTableView.removeFromSuperview()
        transactionTableView = nil
        super.tearDown()
    }

    func testTableViewDisplaysData() {
        // 1) wait for UI updates
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        
        // 2) check tableView contains 2 cells (2 in datasource)
        var tableView: UITableView!
        for sub in transactionTableView.subviews {
            if sub is UITableView {
                tableView = sub as? UITableView
                break
            }
        }
        let numberOfCells = tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfCells, 2, "Expected 2 cells in table view")
        
        // 3) check there are cells in the table
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? TransactionTableCell
        XCTAssertNotNil(cell, "Expected transaction table cell")
        
        // 4) check the text on the cell
        XCTAssertEqual(cell?.summaryLabel.text, "UI test transaction 1001", "Expected summary text to match")
    }
    
}
