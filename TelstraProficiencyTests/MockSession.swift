//
//  MockSession.swift
//  TelstraProficiencyTests
//
//  Created by Navamani, Samuel on 8/12/20.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    
    var resumeCalled = 0
    
    override func resume() {
        resumeCalled += 1
    }
}

class MockSession: URLSession {
    
    var dataTask: MockURLSessionDataTask!
    var request: URLRequest!
    var data: Data!
    var response: URLResponse!
    var error: Error!
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        if let data = data {
            completionHandler(data, nil, nil)
        }
        if let response = response {
            completionHandler(nil, response, nil)
        }
        if let error = error {
            completionHandler(nil, nil, error)
        }
        return dataTask
    }
}
