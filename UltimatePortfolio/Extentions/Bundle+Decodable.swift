//
//  Bundle+Decodable.swift
//  UltimatePortfolio
//
//  Created by Kostya Kondratenko on 04.02.2021.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type,
                              from file: String,
                              dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                              keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Fail to locate \(file) in bundle \(self).")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Fail to load \(file) in bundle \(self).")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            return try decoder.decode(type, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' - \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type missmatch - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to missmatch type value - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Failed to decode \(file) from bundle due to data corruption - \(context.debugDescription)")
        } catch {
            fatalError("Failed to decode \(file) from bundle \(error.localizedDescription)")
        }
    }
}
