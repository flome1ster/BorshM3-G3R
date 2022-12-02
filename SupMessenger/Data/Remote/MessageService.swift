//
//  MessageService.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 31.05.2022.
//

import Foundation
import Alamofire


struct MessageService{
    static let shared = MessageService()
    func listUsers(offset: Int = 0, limit: Int = 100, callback: @escaping(APIResponce<CollectionResponce<UserEntity>>?, Error?)->()){
        AF.request(Config.url + "/messages/users",
                   method: .get,
                  parameters: [
                    "offset":offset,
                    "limit": limit
                  ],
                   headers: [
                   "appToken": Config.appToken,
                   "appSecret": Config.appSecret,
                   "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]).responseDecodable(of: APIResponce<CollectionResponce<UserEntity>>.self){response in
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
    func getMessages(id: Int, group: Bool = false, offset: Int = 0, limit: Int = 100, callback: @escaping(APIResponce<CollectionResponce<MessageEntity>>?, Error?)->()){
        let s = group ? "groups" : "users"
        AF.request(Config.url + "/messages/" + s + "/" + String(id) ,
                   method: .get,
                   parameters: [
                    "offset":offset,
                    "limit": limit
                  ],
                   headers: [
                   "appToken": Config.appToken,
                   "appSecret": Config.appSecret,
                   "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]).responseDecodable(of: APIResponce<CollectionResponce<MessageEntity>>.self){response in
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
    func getGroupMembers(id: Int, group: Bool = true, offset: Int = 0, limit: Int = 100, callback: @escaping(APIResponce<CollectionResponce<UserEntity>>?, Error?)->()){
        AF.request(Config.url + "/messages/groups/" + String(id)  + "/meta",
                   method: .get,
                   parameters: [
                    "offset":offset,
                    "limit": limit
                  ],
                   headers: [
                   "appToken": Config.appToken,
                   "appSecret": Config.appSecret,
                   "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]).responseDecodable(of: APIResponce<CollectionResponce<UserEntity>>.self){response in
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
    func getGroupMessages(id: Int, group: Bool = true, offset: Int = 0, limit: Int = 100, callback: @escaping(APIResponce<CollectionResponce<MessageEntity>>?, Error?)->()){
        let s = group ? "groups" : "users"
        AF.request(Config.url + "/messages/" + s + "/" + String(id) ,
        
                   method: .get,
                   parameters: [
                    "offset":offset,
                    "limit": limit
                  ],
                   headers: [
                   "appToken": Config.appToken,
                   "appSecret": Config.appSecret,
                   "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]).responseDecodable(of: APIResponce<CollectionResponce<MessageEntity>>.self){response in
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
    func sendMessages(data: messageTextEntity, id: Int, callback: @escaping(APIResponce<CollectionResponce<MessageEntity>>?, Error?)->()){
        AF.request(Config.url + "/messages/users/"  + String(id) ,
                   method: .post,
                   parameters: data,
                   headers: [
                   "appToken": Config.appToken,
                   "appSecret": Config.appSecret,
                   "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]).responseDecodable(of: APIResponce<CollectionResponce<MessageEntity>>.self){response in
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
    func sendGroupMessages(data: messageTextEntity, id: Int, callback: @escaping(APIResponce<CollectionResponce<MessageEntity>>?, Error?)->()){
        AF.request(Config.url + "/messages/groups/"  + String(id) ,
                   method: .post,
                   parameters: data,
                   headers: [
                   "appToken": Config.appToken,
                   "appSecret": Config.appSecret,
                   "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]).responseDecodable(of: APIResponce<CollectionResponce<MessageEntity>>.self){response in
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
