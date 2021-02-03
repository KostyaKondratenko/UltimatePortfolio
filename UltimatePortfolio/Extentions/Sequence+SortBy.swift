//
//  Sequence+SortBy.swift
//  UltimatePortfolio
//
//  Created by Kostya Kondratenko on 03.02.2021.
//

import Foundation

extension Sequence {
    func sorted<Value>(by keyPath: KeyPath<Element, Value>, using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Element] {
        try sorted { try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }
    
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        sorted(by: keyPath, using: <)
    }
    
    func sorted(by sortDescriptor: NSSortDescriptor) -> [Element] {
        sorted { sortDescriptor.compare($0, to: $1) == .orderedAscending }
    }
    
    func sorted(by sortDescriptors: [NSSortDescriptor]) -> [Element] {
        sorted {
            for descriptor in sortDescriptors {
                switch descriptor.compare($0, to: $1) {
                case .orderedAscending: return true
                case .orderedDescending: return false
                case .orderedSame: continue
                }
            }
            
            return false
        }
    }
}
