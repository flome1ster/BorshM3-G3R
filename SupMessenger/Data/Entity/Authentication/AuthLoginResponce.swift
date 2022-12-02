//
//  AuthenticationLoginResponce.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//

struct AuthLoginResponce: Codable{
    let access: Token
    let refresh: Token
}
