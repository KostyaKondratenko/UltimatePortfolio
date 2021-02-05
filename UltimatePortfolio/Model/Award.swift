//
//  Award.swift
//  UltimatePortfolio
//
//  Created by Kostya Kondratenko on 04.02.2021.
//

import Foundation

struct Award: Decodable, Identifiable {
    var id: String { name }
    
    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String
    
    static let allAwards = Bundle.main.decode([Self].self, from: "Awards.json")
    static let example = allAwards[0]
}
