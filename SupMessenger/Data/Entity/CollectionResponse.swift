//
//  CollectionResponse.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 31.05.2022.
//

struct CollectionResponce<T: Codable>: Codable{
    let meta: CollectionMeta
    let items: [T]
    
}

struct CollectionMeta: Codable{
    var count: Int? = 0
    var totalCount: Int? = 0
    var userId: Int? = 0
    var creatorId: Int? = 0
}
