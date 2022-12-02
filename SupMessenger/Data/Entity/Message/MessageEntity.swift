//
//  MessageEntity.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 01.06.2022.
//

struct MessageEntity: Codable, Hashable{
    let id: Int
    let userId: Int
    let text: String
    let data: Int
    let read: String
}

