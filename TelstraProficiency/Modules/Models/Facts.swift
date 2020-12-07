//
//  Landing.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 5/12/20.
//

import Foundation

struct Facts: Codable {
    
    let title: String
    let rows: [FactsRow]
}

struct FactsRow: Codable {
    
    let title: String?
    let description: String?
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case title, description
        case url = "imageHref"
    }
}
