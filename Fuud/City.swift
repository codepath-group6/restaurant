//
//  City.swift
//  Fuud
//
//  Created by Eugene Song on 11/6/22.
//

import Foundation

struct City {
    let name: String
    let id: Int
    let wikiDataId: String
    
    init(dict: [String:Any]) {
        name = dict["name"] as! String
        id = dict["id"] as! Int
        wikiDataId = dict["wikiDataId"] as! String
    }
}
