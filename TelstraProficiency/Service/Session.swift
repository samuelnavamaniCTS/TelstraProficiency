//
//  Session.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 7/12/20.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

final class Session: SessionProtocol {
    
    let session: URLSession
    
    init(with session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = session.dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
    }
}
