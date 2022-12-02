//
//  APIResponse.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//

struct APIResponce<T: Codable>: Codable{
    let status: Bool
    let data: T?
    let error: APIError?
}

struct NoReply: Codable {}
