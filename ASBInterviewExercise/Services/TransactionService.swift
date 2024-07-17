//
//  TransactionService.swift
//  ASBInterviewExercise
//
//  Created by yanhu on 17/07/24.
//

import Foundation

// the service containing specific http request
class TransactionService {
    private let restClient: RestClient
    
    init(restClient: RestClient) {
        self.restClient = restClient
    }
    
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        let urlString = "https://gist.githubusercontent.com/Josh-Ng/500f2716604dc1e8e2a3c6d31ad01830/raw/4d73acaa7caa1167676445c922835554c5572e82/test-data.json"
        guard let url = URL(string: urlString) else {
            // a custom error for invalid url
            let err = NSError(domain: "TransactionService", code: 999998, userInfo: [NSLocalizedDescriptionKey: "999998: invalid url"])
            completion(.failure(err))
            return
        }
        
        let urlReq = URLRequest(url: url)
        let _ = restClient.apiRequest(urlReq) { data, resp, err in
            
            if let error = err {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                // a custom error for resp data is nil
                let err = NSError(domain: "TransactionService", code: 999999, userInfo: [NSLocalizedDescriptionKey: "999999: resp data nil"])
                completion(.failure(err))
                return
            }
            
            do {
                let transactions = try JSONDecoder().decode([Transaction].self, from: data)
                completion(.success(transactions))
            } catch {
                completion(.failure(error))
            }
            
        }
    }
}
