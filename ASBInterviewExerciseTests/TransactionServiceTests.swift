//
//  TransactionServiceTests.swift
//  ASBInterviewExerciseTests
//
//  Created by yanhu on 17/07/24.
//

import XCTest

final class TransactionServiceTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testFetchTransactionsSuccess() {
        // Prepare
        let restClient = MockRestClient()
        let transactionService = TransactionService(restClient: restClient)
        let expectation = self.expectation(description: "Fetch transactions")
        
        // Act
        transactionService.fetchTransactions { result in
            switch result {
            case .success(let transactions):
                // Assert
                XCTAssertFalse(transactions.isEmpty, "Transactions should not be empty")
                XCTAssertFalse(transactions.count != 11, "Transactons count not correct")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to fetch transactions with error: \(error)")
            }
        }
        
        // Wait for the expectation to fulfill (async)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchTransactionsFailure() {
        // Prepare
        let restClient = MockRestClient()
        restClient.shouldFail = true // Simulate failure
        let transactionService = TransactionService(restClient: restClient)
        let expectation = self.expectation(description: "Fetch transactions failure")
        
        // Act
        transactionService.fetchTransactions { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure but got success")
            case .failure(let error):
                print("\n\(error.localizedDescription)\n")
                XCTAssertNotNil(error, "Error should not be nil")
                expectation.fulfill()
            }
        }
        
        // Wait for the expectation to fulfill (async)
        waitForExpectations(timeout: 5, handler: nil)
    }

}
