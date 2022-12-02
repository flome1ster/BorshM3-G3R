//
//  GroupService.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 01.06.2022.
//
import Foundation
import Alamofire


struct GroupService{
    static let shared = GroupService()
    func listGroups(offset: Int = 0, limit: Int = 100, callback: @escaping(APIResponce<CollectionResponce<GroupEntity>>?, Error?)->()){
        AF.request(Config.url + "/messages/groups",
                   method: .get,
                  parameters: [
                    "offset":offset,
                    "limit": limit
                  ],
                   headers: [
                   "appToken": Config.appToken,
                   "appSecret": Config.appSecret,
                   "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]).responseDecodable(of: APIResponce<CollectionResponce<GroupEntity>>.self){response in
                       if response.value != nil{
                           if(response.error != nil){
                               callback(response.value, response.error)
                           } else {
                               callback(response.value, nil)
                           }
                           return
                       } else {
                           callback(nil, response.error)
                       }
                   }
    }
}
