//
//  NetworkAPI.swift
//  bjssKennyChen
//
//  Created by NYCDOE on 1/22/20.
//  Copyright © 2020 hireMeKennyChen. All rights reserved.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    let id: Int
    let name: String
    let price: Price
    let container: String?
}

// MARK: - Price
struct Price: Codable {
    let amount: Double
    let currency: Currency
}

enum Currency: String, Codable {
    case eur = "EUR"
    case gbp = "GBP"
}

typealias Products = [Product]

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func productsTask(with url: URL, completionHandler: @escaping (Products?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
