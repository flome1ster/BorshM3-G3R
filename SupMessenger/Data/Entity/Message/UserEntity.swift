//
//  MessageEntity.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 31.05.2022.
//

import Foundation

struct UserEntity: Codable, Hashable{
    let id: Int
    let name: String
    let role: String?
    let online: Bool
    let avatar: String?
    let date: Int?
    let unread: Int?
}

