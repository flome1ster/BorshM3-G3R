//
//  UserViewModel.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//

import Foundation
import Alamofire
struct AuthData: Codable{
    let token: String
}

class UserViewModel : ObservableObject {
    @Published var user: User = User(email: "", password: "", passwordRepeat: "")
    @Published var isRegistr : Bool = false
    @Published var accessToken = UserDefaults.standard.string(forKey: "accToken")
    @Published var refreshToken = UserDefaults.standard.string(forKey: "refToken")
    @Published var authData: AuthData? = nil
    @Published var alert: Bool = false
    @Published var errorMessage: String = ("")
    @Published var listMessage: [UserEntity] = []
    @Published var groupMessage: [GroupEntity] = []
    @Published var takeMessage: [MessageEntity] = []
    @Published var groupUsers: [UserEntity] = []
    @Published var groupMeta: CollectionMeta = CollectionMeta(count: 0, totalCount: 0, userId: 0, creatorId: 0)
    var myId = -1
    @Published var textMessage: messageTextEntity = messageTextEntity(text: "")
    @Published var lastMessageId: Int = 0
    @Published var doubleDate: Double = 0
    
    
    func registration(){
        AF.request("http://cinema.areas.su/auth/register",
                   method: .post,
                   parameters: [
                    "email": user.email,
                    "password": user.password
                   ]
        )
        .responseString{response in
            if response.value != nil {
                self.isRegistr = true
                UserDefaults.standard.set(self.isRegistr, forKey: "isReg")
            }
            else {
                self.alert = true
                self.errorMessage = ("Не удалось выполнить регистрацию")
                print(response)
            }
        }
    }
    
    func login(){
        AuthenticationService.shared.login(data: AuthenticationRequest(login: user.email, password: user.password)){response, error in
            if(response != nil ){
                if response!.status{
                    self.accessToken = response?.data?.access.token
                    self.refreshToken = response?.data?.refresh.token
                    UserDefaults.standard.set(self.accessToken, forKey: "accToken")
                    UserDefaults.standard.set(self.refreshToken, forKey: "refToken")
                    self.isRegistr = true
                    UserDefaults.standard.set(self.isRegistr, forKey: "isReg")
                    print(self.accessToken!)
                    print(self.refreshToken!)
                }else{
                    self.alert = true
                    self.errorMessage = "Код: \(String(describing:response?.error?.code))\nОшибка: \(String(describing: response?.error?.message))\nОписание:\(String(describing:response?.error?.description))"
                }
            }else {
                self.alert = true
                self.errorMessage = "Проверьте подключение к интернету"
                //print(error)
            }
        }
    }
    func getListMes(){
        MessageService.shared.listUsers(offset: 0, limit: 100){response, error in
            if(response != nil){
                if response!.status{
                    self.listMessage = response?.data?.items ?? []
                    print("123")
                } else {
                    self.alert = true
                    self.errorMessage = "Код: \(String(describing:response?.error?.code))\nОшибка: \(String(describing: response?.error?.message))\nОписание:\(String(describing:response?.error?.description))"
                    print("no status")
                }
            } else {
                self.alert = true
                self.errorMessage = "Проверьте подключение к интернету"
                print(error!)
            }
        }
    }
    func getListGroup(){
        GroupService.shared.listGroups(offset: 0, limit: 100){response, error in
            if(response != nil){
                if response!.status{
                    self.groupMessage = response?.data?.items ?? []
                    print("123")
                } else {
                    self.alert = true
                    self.errorMessage = "Код: \(String(describing:response?.error?.code))\nОшибка: \(String(describing: response?.error?.message))\nОписание:\(String(describing:response?.error?.description))"
                    print("no status")
                }
            } else {
                self.alert = true
                self.errorMessage = "Проверьте подключение к интернету"
                print(error!)
            }
        }
    }
    func getUserMessage(userId: Int){
        MessageService.shared.getMessages(id: userId, offset: 0, limit: 100){response, error in
            if(response != nil){
                if response!.status{
                    self.takeMessage = response?.data?.items ?? []
                    print("123")
                    if let id = self.takeMessage.first?.id{
                        self.lastMessageId = id
                    }
                } else {
                    self.alert = true
                    self.errorMessage = "Код: \(String(describing:response?.error?.code))\nОшибка: \(String(describing: response?.error?.message))\nОписание:\(String(describing:response?.error?.description))"
                    print("no status")
                }
            } else {
                self.alert = true
                self.errorMessage = "Проверьте подключение к интернету"
                print(error!)
            }
        }
    }
    func getGroupUsers(id: Int, callback: @escaping()->()){
        MessageService.shared.getGroupMembers(id: id, group: true, offset: 0, limit: 100){response, error in
            if(response != nil){
                if response!.status{
                    self.groupMeta = (response?.data!.meta)!
                    self.listMessage =  response?.data?.items ?? []
                    callback()
                } else {
                    self.alert = true
                    self.errorMessage = "Код: \(String(describing:response?.error?.code))\nОшибка: \(String(describing: response?.error?.message))\nОписание:\(String(describing:response?.error?.description))"
                    print("no status")
                }
            } else {
                self.alert = true
                self.errorMessage = "Проверьте подключение к интернету"
                print(error!)
            }
        }
    }
    func getGroupMessage(userId: Int){
        MessageService.shared.getGroupMessages(id: userId, offset: 0, limit: 100){response, error in
            if(response != nil){
                if response!.status{
                    self.takeMessage = response?.data?.items ?? []
                    print("123")
                    if let id = self.takeMessage.first?.id{
                        self.lastMessageId = id
                    }
                   
                } else {
                    self.alert = true
                    self.errorMessage = "Код: \(String(describing:response?.error?.code))\nОшибка: \(String(describing: response?.error?.message))\nОписание:\(String(describing:response?.error?.description))"
                    print("no status")
                }
            } else {
                self.alert = true
                self.errorMessage = "Проверьте подключение к интернету"
                print(error!)
            }
        }
    }
    func sendMessage(userId: Int){
        MessageService.shared.sendMessages(data: messageTextEntity(text: textMessage.text), id: userId){response, error in
            if(response != nil){
                if response!.status{
                    self.takeMessage = response?.data?.items ?? []
                    self.getUserMessage(userId: userId)
                    print("123")
                    
                } else {
                    self.alert = true
                    self.errorMessage = "Код: \(String(describing:response?.error?.code))\nОшибка: \(String(describing: response?.error?.message))\nОписание:\(String(describing:response?.error?.description))"
                    print("no status")
                }
            } else {
                self.alert = true
                self.errorMessage = "Проверьте подключение к интернету"
                print(error!)
            }
        }
        
    }
    func sendGroupMessage(userId: Int){
        MessageService.shared.sendGroupMessages(data: messageTextEntity(text: textMessage.text), id: userId){response, error in
            if(response != nil){
                if response!.status{
                    self.takeMessage = response?.data?.items ?? []
                    self.getGroupMessage(userId: userId)
                    print("123")
                    
                } else {
                    self.alert = true
                    self.errorMessage = "Код: \(String(describing:response?.error?.code))\nОшибка: \(String(describing: response?.error?.message))\nОписание:\(String(describing:response?.error?.description))"
                    print("no status")
                }
            } else {
                self.alert = true
                self.errorMessage = "Проверьте подключение к интернету"
                print(error!)
            }
        }
        
    }
}
