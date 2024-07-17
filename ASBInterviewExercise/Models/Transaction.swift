//
//  Transaction.swift
//  ASBInterviewExercise
//
//  Created by yanhu on 17/07/24.
//

import Foundation

// Transaction Model represents for a transaction
struct Transaction: Codable {
    let id: Int
    let transactionDate: String
    let summary: String
    let debit: Double
    let credit: Double
    
    // computed properties to determine the type of transaction
    var isDebit: Bool {
        return debit > 0
    }
    
    var amount: Double {
        return isDebit ? debit : credit
    }
    
    var gst: Double {
        return amount * 0.15 / 1.15
    }
    
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: transactionDate) ?? Date()
    }
}

