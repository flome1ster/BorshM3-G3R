//
//  Token.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//

struct Token: Codable{
    let token: String
    let type: TokenType
    let lifetime: Int
    let createdAt: Int
}
