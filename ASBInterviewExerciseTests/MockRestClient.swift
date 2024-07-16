//
//  MockRestClient.swift
//  ASBInterviewExerciseTests
//
//  Created by yanhu on 17/07/24.
//

import Foundation

protocol RestClient {
    func apiRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

// a mock rest client to simulate http request results
class MockRestClient: RestClient {
    
    var mockData: Data? {
        let jsonString = """
        [
            {"id":1,"transactionDate":"2021-08-31T15:47:10","summary":"Hackett, Stamm and Kuhn","debit":9379.55,"credit":0},
            {"id":2,"transactionDate":"2022-02-17T10:44:35","summary":"Hettinger, Wilkinson and Kshlerin","debit":3461.35,"credit":0},
            {"id":3,"transactionDate":"2021-02-21T08:19:12","summary":"McKenzie, Bins and Macejkovic","debit":0,"credit":1415.74},
            {"id":4,"transactionDate":"2021-12-15T14:35:20","summary":"Treutel, Schaden and Pfannerstill","debit":1639.43,"credit":0},
            {"id":5,"transactionDate":"2021-05-31T07:17:56","summary":"Mitchell-Schamberger","debit":4436.26,"credit":0},
            {"id":6,"transactionDate":"2021-04-01T23:34:27","summary":"Heidenreich and Sons","debit":0,"credit":1537.53},
            {"id":7,"transactionDate":"2021-01-20T00:02:36","summary":"Ziemann, Towne and Leffler","debit":9663.17,"credit":0},
            {"id":8,"transactionDate":"2021-04-16T05:28:52","summary":"Rath-Kertzmann","debit":2376.4,"credit":0},
            {"id":9,"transactionDate":"2022-01-24T19:29:41","summary":"Prosacco Group","debit":0,"credit":7740.36},
            {"id":10,"transactionDate":"2021-04-14T10:31:46","summary":"Kunze Inc","debit":2580.68,"credit":0},
            {"id":11,"transactionDate":"2021-09-02T10:52:57","summary":"Howell, Steuber and Sporer","debit":9197.5,"credit":0}
        ]
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Failed to convert JSON string to Data")
        }
        return jsonData
    }
    
    // should simulate a failure
    var shouldFail: Bool = false
    
    func apiRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if shouldFail {
            let error = NSError(domain: "MockRestClient", code: 500, userInfo: [NSLocalizedDescriptionKey: "500: MockRestClient Simulated error"])
            completion(nil, nil, error)
        } else {
            completion(mockData, nil, nil)
        }
    }
    
}
