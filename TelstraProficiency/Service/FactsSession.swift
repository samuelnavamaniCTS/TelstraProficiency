//
//  FactsSession.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 7/12/20.
//

import Foundation

enum FactsSessionError: Error {
    case invalidResponse
    case invalidData
    case cancelled
}

protocol FactsSessionProtocol {
    func executeRequest(with endpoint: URL, completion: @escaping (Result<Data?, Error>) -> Void) -> URLSessionDataTask
}

final class FactsSession {
    
    //MARK: - Properties
    
    static let shared = FactsSession()
    
    private let session: SessionProtocol
    
    //MARK: - Initialiser Methods
    
    init(with session: SessionProtocol = Session()) {
        self.session = session
    }
}

//MARK: - FactsSessionProtocol Methods

extension FactsSession: FactsSessionProtocol {
    
    func executeRequest(with endpoint: URL, completion: @escaping (Result<Data?, Error>) -> Void) ->  URLSessionDataTask {
        
        let request = URLRequest(url: endpoint)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(FactsSessionError.invalidResponse))
                    return
            }
                
            if let error = error {
                if (error as NSError).code == NSURLErrorCancelled {
                    completion(.failure(FactsSessionError.cancelled))
                } else {
                    completion(.failure(error))
                }
                return
            }
            
            if let data = data {
                return completion(.success(data))
            } else {
                return completion(.failure(FactsSessionError.invalidData))
            }

        }
        return task
    }
}
