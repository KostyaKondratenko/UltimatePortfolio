//
//  Binding+OnChange.swift
//  UltimatePortfolio
//
//  Created by Kostya Kondratenko on 02.02.2021.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(get: { wrappedValue },
                set: { wrappedValue = $0; handler() })
    }
}
