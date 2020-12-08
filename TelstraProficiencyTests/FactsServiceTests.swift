//
//  FactsServiceTests.swift
//  TelstraProficiencyTests
//
//  Created by Navamani, Samuel on 8/12/20.
//

import XCTest
@testable import TelstraProficiency

class MockFactsSessionProtocol: FactsSessionProtocol {
    var data: Data!
    var error: Error!
    var mockURLSessionDataTask: MockURLSessionDataTask!
    
    func executeRequest(with endpoint: URL, completion: @escaping (Result<Data?, Error>) -> Void) -> URLSessionDataTask {
        if let data = data {
            completion(.success(data))
        }
        
        if let error = error {
            completion(.failure(error))
        }
        return mockURLSessionDataTask
    }
    
    
}
class FactsServiceTests: XCTestCase {
    var sut: FactsService!
    var mockSessionProtocol: MockFactsSessionProtocol!
    
    func testFailure() {
        mockSessionProtocol = MockFactsSessionProtocol()
        mockSessionProtocol.error = FactsSessionError.invalidData
        let mockURLSessionDataTask = MockURLSessionDataTask()
        mockURLSessionDataTask.resumeCalled = 200
        mockSessionProtocol.mockURLSessionDataTask = mockURLSessionDataTask
        
        sut = FactsService(with: mockSessionProtocol)
        let promise = expectation(description: "Response will fail with error.")
        
        var passedError: Error?
        sut.getFacts { result in
            switch result {
            case .failure(let error):
                passedError = error
                promise.fulfill()
            case .success(_):
                XCTFail("testFailure - Should fail.")
            }
        }
        
        //Then
        wait(for: [promise], timeout: 1)
        XCTAssertEqual(passedError as! FactsSessionError, FactsSessionError.invalidData)
    }
    

}
