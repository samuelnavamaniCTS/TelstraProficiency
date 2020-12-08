//
//  FactsSessionTests.swift
//  TelstraProficiencyTests
//
//  Created by Navamani, Samuel on 8/12/20.
//

import XCTest
@testable import TelstraProficiency

class MockSessionProtocol: SessionProtocol {
    
    var request: URLRequest!
    var data: Data!
    var response: URLResponse!
    var error: Error!
    var sessionDataTask: MockURLSessionDataTask!
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        if let data = data, let response = response {
            completionHandler(data, response, nil)
        } else if let error = error, let response = response {
            completionHandler(nil, response, error)
        } else if let response = response {
            completionHandler(nil, response, nil)
        }
        return sessionDataTask
    }
}

class FactsSessionTests: XCTestCase {

    var sut: FactsSession!
    var mockSessionProtocol: MockSessionProtocol!
    var mockResponse: URLResponse!
    
    func testInvalidResponse() {
        //Given
        mockSessionProtocol = MockSessionProtocol()
        mockResponse = HTTPURLResponse(url: URL(string: "www.mockResponseURL.com")!, statusCode: 2001, httpVersion: nil, headerFields: [:])
        mockSessionProtocol.response = mockResponse
        let dataTask = MockURLSessionDataTask()
        dataTask.resumeCalled = 2001
        mockSessionProtocol.sessionDataTask = dataTask
        sut = FactsSession(with: mockSessionProtocol)
        let promise = expectation(description: "Response will fail with error.")
        
        //When
        var passedError: Error?
        let sessionDataTask = sut.executeRequest(with: URL(string: "www.mockResponseURL.com")!) { result in
            switch result {
            case .failure(let error):
                passedError = error
                promise.fulfill()
            case .success(_):
                XCTFail("testInvalidResponse - Should fail.")
            }
        }
        
        //Then
        wait(for: [promise], timeout: 1)
        XCTAssertEqual(passedError as! FactsSessionError, FactsSessionError.invalidResponse)
        let taskValue = (sessionDataTask as? MockURLSessionDataTask)?.resumeCalled
        XCTAssertEqual(taskValue, 2001)
    }
    
    func testResponseWithError() {
        //Given
        mockSessionProtocol = MockSessionProtocol()
        mockResponse = HTTPURLResponse(url: URL(string: "www.mockResponseURL.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])
        mockSessionProtocol.response = mockResponse
        mockSessionProtocol.error = FactsSessionError.invalidData
        let dataTask = MockURLSessionDataTask()
        dataTask.resumeCalled = 200
        mockSessionProtocol.sessionDataTask = dataTask
        sut = FactsSession(with: mockSessionProtocol)
        let promise = expectation(description: "Response will fail with error.")
        
        //When
        var passedError: Error?
        let sessionDataTask = sut.executeRequest(with: URL(string: "www.mockResponseURL.com")!) { result in
            switch result {
            case .failure(let error):
                passedError = error
                promise.fulfill()
            case .success(_):
                XCTFail("testResponseWithError - Should fail.")
            }
        }
        
        //Then
        wait(for: [promise], timeout: 1)
        XCTAssertEqual(passedError as! FactsSessionError, FactsSessionError.invalidData)
        let taskValue = (sessionDataTask as? MockURLSessionDataTask)?.resumeCalled
        XCTAssertEqual(taskValue, 200)
    }
    
    func testCorrectData() {
        //Given
        mockSessionProtocol = MockSessionProtocol()
        mockResponse = HTTPURLResponse(url: URL(string: "www.mockResponseURL.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])
        mockSessionProtocol.response = mockResponse
        mockSessionProtocol.data = "Test data".data(using: .utf8)
        let dataTask = MockURLSessionDataTask()
        dataTask.resumeCalled = 200
        mockSessionProtocol.sessionDataTask = dataTask
        sut = FactsSession(with: mockSessionProtocol)
        let promise = expectation(description: "Succeed with error.")
        
        //When
        var passedData: Data?
        let sessionDataTask = sut.executeRequest(with: URL(string: "www.mockResponseURL.com")!) { result in
            switch result {
            case .failure(_):
                XCTFail("testCorrectData - Should Succeed.")
            case .success(let data):
                passedData = data
                promise.fulfill()
            }
        }
        
        //Then
        wait(for: [promise], timeout: 1)
        XCTAssertEqual(String(data: passedData!, encoding: .utf8), "Test data")
        let taskValue = (sessionDataTask as? MockURLSessionDataTask)?.resumeCalled
        XCTAssertEqual(taskValue, 200)
    }
    
    override func tearDown() {
        sut = nil
        mockSessionProtocol = nil
        mockResponse = nil
    }

}
