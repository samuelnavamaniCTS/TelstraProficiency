//
//  SessionTests.swift
//  TelstraProficiencyTests
//
//  Created by Navamani, Samuel on 8/12/20.
//

import XCTest
@testable import TelstraProficiency

class SessionTests: XCTestCase {
    
    var sut: Session!
    var mockSession: MockSession!
    var mockURL: URL!
    var mockRequest: URLRequest!
    var mockDataTask: MockURLSessionDataTask!

    func testIfSessionReturnsCorrectValues() {
         //Given
         mockDataTask = MockURLSessionDataTask()
         mockURL =  URL(string: "www.testURL.com")
         mockRequest = URLRequest(url: mockURL)
         mockRequest.httpMethod = "MOCKPOST"
         mockSession = MockSession()
         mockSession.dataTask = mockDataTask
         mockSession.request = mockRequest
         mockSession.data = Data()
         sut = Session(with: mockSession)
         let promise = expectation(description: "Completion handler with data invoked")
         
         //When
         var passedData: Data?
         let _ = sut.dataTask(with: mockRequest) { data, response, error in
             if let data = data {
                 XCTAssertNil(response)
                 XCTAssertNil(error)
                 passedData = data
                 promise.fulfill()
             } else {
                 XCTFail("testIfSessionReturnsCorrectValues Should have data available")
             }
         }
         
         wait(for: [promise], timeout: 1)
         
         //Then
         XCTAssertNotNil(mockSession.request)
         XCTAssertEqual(mockURL, mockSession.request.url)
         XCTAssertEqual(mockSession.request.httpMethod!, "MOCKPOST")
         XCTAssertNotNil(passedData)
         XCTAssertEqual(mockDataTask.resumeCalled, 1)
     }

    override func tearDown() {
         sut = nil
         mockSession = nil
     }

}
