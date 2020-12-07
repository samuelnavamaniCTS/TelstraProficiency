//
//  FactsViewModel.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 7/12/20.
//

import Foundation

final class FactsViewModel {
    
    let service: FactsServiceProtocol
    var facts: Facts? {
        didSet {
            print(String(describing: facts))
        }
    }
    
    init(with service: FactsServiceProtocol = FactsService()) {
        self.service = service
    }
    
    func getFacts() {
        service.getFacts { result in
            switch result {
            case .success(let facts):
                self.facts = facts
            case .failure(let error):
                print(error)
            }
        }
    }
}
