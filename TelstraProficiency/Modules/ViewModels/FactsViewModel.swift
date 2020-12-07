//
//  FactsViewModel.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 7/12/20.
//

import Foundation
import UIKit


/// Delegate of the view model to notify updates.
protocol FactsViewModelDelegate: AnyObject {
    func didUpdate(_ viewModel: FactsViewModel, error: Error?)
}


/// Protocol for the  view model decouples and testable methods.
protocol FactsViewModelProtocol {
    func getFacts()
    func loadImage(from imageUrl: URL, completion: @escaping (UIImage) -> Void) -> UUID?
    func cancelLoad(token: UUID)
}

final class FactsViewModel {
    
    //MARK: - Delegate Properties
    
    weak var delegate: FactsViewModelDelegate?
    
    //MARK: - Properties
    
    private let service: FactsServiceProtocol
    private let imageLoaderService: ImageLoaderServiceProtocol
    private var facts: Facts? {
        didSet {
            delegate?.didUpdate(self, error: nil)
        }
    }
    
    //MARK: - Initialiser Methods
    
    init(with service: FactsServiceProtocol = FactsService(),
         imageLoaderService: ImageLoaderServiceProtocol = ImageLoaderService()) {
        self.service = service
        self.imageLoaderService = imageLoaderService
    }
}

//MARK: - FactsViewModelProtocol methods

extension FactsViewModel: FactsViewModelProtocol {
    
    func getFacts() {
        service.getFacts { result in
            switch result {
            case .success(let facts):
                let rows = facts.rows.filter { $0.title != nil || $0.description != nil || $0.url != nil}
                let allFacts = Facts(title: facts.title, rows: rows)
                print(String(describing: allFacts))
                
                self.facts = allFacts
            case .failure(let error):
                print(error)
                self.delegate?.didUpdate(self, error: error)
            }
        }
    }
    
    func loadImage(from imageUrl: URL, completion: @escaping (UIImage) -> Void) -> UUID? {
        
        let token = imageLoaderService.loadImage(imageUrl) { result in
          do {
            let image = try result.get()
            DispatchQueue.main.async {
              completion(image)
            }
          } catch {
            print(error)
          }
        }
        return token
    }
    
    func cancelLoad(token: UUID) {
        self.imageLoaderService.cancelLoad(token)
    }
}

//MARK: - Table Datasource methods

extension FactsViewModel {
    
    func numberOfRowsInSection() -> Int {
        facts?.rows.count ?? 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> FactsRow? {
        var row: FactsRow?
        if let count = facts?.rows.count, count > 0 {
            row = facts?.rows[indexPath.row]
        }
        return row
    }
    
    func factsTitle() -> String {
        facts?.title ?? "Facts"
    }
}

