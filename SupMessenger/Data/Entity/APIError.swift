//
//  APIError.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//

struct APIError: Codable{
    var code: Int = 0
    var message: String = ""
    var description: String = ""
}
