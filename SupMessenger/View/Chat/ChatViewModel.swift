//
//  ChatViewModel.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 15.06.2022.
//

import Foundation
import Alamofire


class ChatViewModel: ObservableObject{
    @Published var messages: [MessageEntity] = []
    @Published var users: [UserEntity] = []
    @Published var input: String = ""
    var userId = -1
    var isGroup = false
    var myId = -1
    private var currentPage = 1
    private let limit = 30
    @Published var endReached = false
    @Published var error: APIError?
    @Published var sendStatus = 0
    
    init(){
        print("init")
    }
    
    func setup(id: Int, isGroup: Bool){
        self.userId = id
        self.isGroup = isGroup
        if isGroup {
            fetchUsers()
        }
    }
    
    func fetchUsers(){
        AF.request(Config.url + "/messages/groups/" + userId.description + "/meta", method: .get,
                   parameters: [
                    "offset":  0,
                    "limit": 100
                   ],
                   headers: [
                    "appToken": Config.appToken,
                    "appSecret": Config.appSecret,
                    "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]).responseDecodable(of: APIResponce<CollectionResponce<UserEntity>>.self){responce in
                       
                       switch(responce.result){
                       case .failure(let error):
                           self.error = APIError(code: error.responseCode!, message: error.errorDescription!, description: error.localizedDescription)
                           break
                       case .success(let data):
                           //self.fetchNext()
                           print("users loades")
                           self.myId = data.data!.meta.userId ?? -1
                           self.users.append(contentsOf: data.data!.items)
                           break
                       }
                       
                   }
    }
    
    func fetchNext()
    {
        if self.error != nil { self.error = nil}
        AF.request(Config.url + (isGroup ? "/messages/groups/" : "/messages/users/") + userId.description, method: .get,
                   parameters: [
                    "offset": (currentPage - 1) * limit ,
                    "limit": limit
                   ],
                   headers: [
                    "appToken": Config.appToken,
                    "appSecret": Config.appSecret,
                    "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]).responseDecodable(of: APIResponce<CollectionResponce<MessageEntity>>.self){responce in
                       
                       switch(responce.result){
                       case .failure(let error):
                           self.error = APIError(code: error.responseCode ?? 0, message: error.errorDescription!, description: error.localizedDescription)
                           break
                       case .success(let data):
                           print("messages loaded")
                           self.messages.append(contentsOf: data.data!.items)
                           if self.currentPage == 1 {
                               self.read(lastId: self.messages.first?.id)
                           }
                           self.currentPage += 1
                           if data.data!.items.count < self.limit {
                               self.endReached = true
                           }
                           break
                       }
                   }
    }
    
    func send(){
        
        self.sendStatus = 1
        if(!self.input.isEmpty){
            AF.request(Config.url + (isGroup ? "/messages/groups/" : "/messages/users/")  + String(self.userId) ,
                   method: .post,
                       parameters: messageTextEntity(text: self.input.trimmingCharacters(in: .whitespacesAndNewlines)),
                   headers: [
                   "appToken": Config.appToken,
                   "appSecret": Config.appSecret,
                   "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]).responseDecodable(of: APIResponce<NoReply>.self){ response in
                       switch (response.result){
                       case .failure(let error):
                           self.sendStatus = 2
                           break
                       case .success(let data):
                           self.input = ""
                           self.sendStatus = 0
                           self.messages = []
                           self.currentPage = 1
                           self.fetchNext()
                           break
                       }
                   }
        }
    }
    
    func read(lastId: Int?){
        AF.request(Config.url + (isGroup ? "/messages/groups/" : "/messages/users/")  + String(self.userId) ,
               method: .put,
                   parameters: [
                    "lastId": lastId
                    
                   ],
               headers: [
               "appToken": Config.appToken,
               "appSecret": Config.appSecret,
               "accessToken": UserDefaults.standard.string(forKey: "accToken")!
               ]).responseDecodable(of: APIResponce<NoReply>.self){  response in
                   switch(response.result){
                   case .failure(let error):
                       print(error)
                       break
                   case .success(let data):
                       print(data)
                       break
                   }
               }
    }
}
