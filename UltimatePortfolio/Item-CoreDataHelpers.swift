//
//  Item-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Kostya Kondratenko on 01.02.2021.
//

import Foundation

extension Item {
    enum SortOrder {
        case optimized, title, creationDate
    }
    
    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item in project.")
    }
    
    var itemDetail: String {
        detail ?? ""
    }
    
    var itemCreationDate: Date {
        creationDate ?? Date()
    }
    
    static var example: Item {
        let controller = DataController(inMemory: true)
        let context = controller.container.viewContext
        
        let item = Item(context: context)
        item.title = "Example item"
        item.detail = "This is an example item."
        item.priority = 3
        item.creationDate = Date()
        
        return item
    }
}
