//
//  Session.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 7/12/20.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

final class Session {
    
    //MARK: - Properties
    
    private let session: URLSession
    
    //MARK: - Initliaser Methods
    
    init(with session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
}

//MARK: - SessionProtocol Methods

extension Session: SessionProtocol {

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
        return dataTask
    }
}
