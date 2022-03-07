//
//  CountrysNameModel.swift
//  SportApp
//
//  Created by Pola on 2/23/22.
//  Copyright © 2022 Pola. All rights reserved.
//

import Foundation
struct CountryNameRoot: Codable{
    
    let countries : [CountriesName]?

        enum CodingKeys: String, CodingKey {
            case countries = "countries"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            countries = try values.decodeIfPresent([CountriesName].self, forKey: .countries)
        }

    }
    

struct CountriesName: Codable {
    let name_en : String?

    enum CodingKeys: String, CodingKey {
        case name_en = "name_en"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name_en = try values.decodeIfPresent(String.self, forKey: .name_en)
    }

}
