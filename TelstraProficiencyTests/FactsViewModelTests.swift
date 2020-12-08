//
//  FactsViewModel.swift
//  TelstraProficiencyTests
//
//  Created by Navamani, Samuel on 8/12/20.
//

import XCTest
@testable import TelstraProficiency

class MockFactsService: FactsServiceProtocol {
    
    var facts: Facts!
    var error: Error!
    
    func getFacts(with completion: @escaping (Result<Facts, Error>) -> Void) {
        if let facts = facts {
            completion(.success(facts))
        }
        
        if let error = error {
            completion(.failure(error))
        }
    }
}

class MockImageLoaderService: ImageLoaderServiceProtocol {
    
    var image: UIImage!
    var url: URL!
    var error: Error!
    var uuid: UUID!
    var cancelCount = 0
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        if let image = image {
            completion(.success(image))
        }
        if let error = error {
            completion(.failure(error))
        }
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        cancelCount += 1
    }
}

class MockFactsViewModelDelegate: FactsViewModelDelegate {
    var didUpdateCalled: Int = 0
    var error: Error?
    func didUpdate(_ viewModel: FactsViewModel, error: Error?) {
        didUpdateCalled += 1
        self.error = error
    }
}

class FactsViewModelTests: XCTestCase {
    var sut: FactsViewModel!
    var mockFactsService: MockFactsService!
    var mockImageLoaderService: MockImageLoaderService!
    var mockDelegate: MockFactsViewModelDelegate!
    
    func testsSuccessfulGetFacts() {
        mockFactsService = MockFactsService()
        let facts = FactsViewModelTests.createFacts()
        mockFactsService.facts = facts
        mockDelegate = MockFactsViewModelDelegate()
        
        sut = FactsViewModel(with: mockFactsService, imageLoaderService: MockImageLoaderService())
        sut.delegate = mockDelegate
        
        sut.getFacts()
        
        XCTAssertEqual(mockDelegate.didUpdateCalled, 1)
    }
    
    func testsSuccessfulGetFactsWithoutNill() {
        mockFactsService = MockFactsService()
        let facts = FactsViewModelTests.createFactsWithNull()
        mockFactsService.facts = facts
        mockDelegate = MockFactsViewModelDelegate()
        
        sut = FactsViewModel(with: mockFactsService, imageLoaderService: MockImageLoaderService())
        sut.delegate = mockDelegate
        
        sut.getFacts()
        
        XCTAssertEqual(mockDelegate.didUpdateCalled, 1)
        XCTAssertEqual(sut.numberOfRowsInSection(), 2)
        XCTAssertEqual(sut.factsTitle(), "About Canada")
        XCTAssertEqual(sut.cellForRowAt(indexPath: IndexPath(row: 0, section: 1))?.title, "Beavers")
    }
    
    func testsErrorGetFacts() {
        mockFactsService = MockFactsService()
        mockFactsService.error = FactsSessionError.invalidData
        mockDelegate = MockFactsViewModelDelegate()
        
        sut = FactsViewModel(with: mockFactsService, imageLoaderService: MockImageLoaderService())
        sut.delegate = mockDelegate
        
        sut.getFacts()
        
        XCTAssertEqual(mockDelegate.didUpdateCalled, 1)
        XCTAssertEqual(mockDelegate.error as! FactsSessionError, FactsSessionError.invalidData)
    }
}

extension FactsViewModelTests {
    
    static func createFacts() -> Facts {
        let JSON = """
        {
        "title":"About Canada",
        "rows":[
            {
            "title":"Beavers",
            "description":"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony",
            "imageHref":"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"
            }
        ]
        }
        """
        
        let jsonData = JSON.data(using: .utf8)!
        let facts = try! JSONDecoder().decode(Facts.self, from: jsonData)
        return facts
    }
    
    static func createFactsWithNull() -> Facts {
        let JSON = """
        {
        "title":"About Canada",
        "rows":[
            {
            "title":"Beavers",
            "description":"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony",
            "imageHref":"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"
            },
            {
            "title": null,
            "description": null,
            "imageHref": null
            },
            {
            "title":"Beavers1",
            "description":"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony",
            "imageHref":"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"
            }
        ]
        }
        """
        
        let jsonData = JSON.data(using: .utf8)!
        let facts = try! JSONDecoder().decode(Facts.self, from: jsonData)
        return facts
    }
}
