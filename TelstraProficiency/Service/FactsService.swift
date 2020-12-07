//
//  FactsService.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 7/12/20.
//

import Foundation

protocol FactsServiceProtocol {
    func getFacts(with completion: @escaping (Result<Facts, Error>) -> Void)
}

struct FactsService {
    
    private let session: FactsSessionProtocol
    
    init(with session: FactsSessionProtocol = FactsSession.shared) {
        self.session = session
    }
}

extension FactsService: FactsServiceProtocol {
    
    func getFacts(with completion: @escaping (Result<Facts, Error>) -> Void) {
        
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
        let _ = session.executeRequest(with: url) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    //Content type of response is "text/plain; charset=ISO-8859-1" and not json
                    let str = String(decoding: Data(data), as: UTF8.self)
                    if let data = str.data(using: String.Encoding.utf8 ) {
                        DispatchQueue.main.async {
                            let details = JSONToModelTransformer.convert(data: data, to: Facts.self)
                            completion(details)
                        }
                    }
                }
            case .failure(let error):
                print("Facts service failed with error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
