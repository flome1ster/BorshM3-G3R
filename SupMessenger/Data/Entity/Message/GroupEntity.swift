//
//  GroupEntity.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 01.06.2022.
//
import Foundation

struct GroupEntity: Codable, Hashable{
    let id: Int
    let name: String
    let count: Int
    let date: Int
    let unread: Int
   
}

