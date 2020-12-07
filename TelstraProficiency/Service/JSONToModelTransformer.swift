//
//  JSONToModelTransformer.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 7/12/20.
//

import Foundation

/// Helper class for json to model transformation
struct JSONToModelTransformer<T: Codable> {

    static func convert(data: Data, to modelType: T.Type = T.self) -> Result<T, Error> {
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return .success(model)
        } catch let error {
            return .failure(error)
        }
    }
    
    static func convert(model: T) -> Result<Data, Error> {
        do {
            let data = try JSONEncoder().encode(model)
            return .success(data)
        } catch let error {
            return .failure(error)
        }
    }
}
