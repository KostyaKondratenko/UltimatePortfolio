//
//  Project-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Kostya Kondratenko on 01.02.2021.
//

import Foundation

extension Project {
    var projectTitle: String {
        title ?? "New Project"
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }
    
    var projectItems: [Item] {
        (items?.allObjects as? [Item] ?? []).sorted {
            if !$0.completed {
                if $1.completed {
                    return true
                }
            } else if $0.completed {
                if !$1.completed {
                    return false
                }
            }
            
            if $0.priority > $1.priority {
                return true
            } else if $0.priority < $1.priority  {
                return false
            }
            
            return $0.itemCreationDate < $1.itemCreationDate
        }
    }
    
    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else { return 0 }
        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }
    
    static var example: Project {
        let container = DataController(inMemory: true)
        let context = container.container.viewContext
        
        let project = Project(context: context)
        project.title = "Example Project"
        project.detail = "This is an example project."
        project.closed = true
        project.creationDate = Date()
        
        return project
    }
}
