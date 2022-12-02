//
//  NotificationService.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 10.06.2022.
//

import Foundation
import Alamofire

struct NotificationService{
    
    static let shared = NotificationService()
    
    func setFcmToken(token: String, callback: @escaping(APIResponce<NoReply>?, Error?) -> ()){
        AF.request(Config.url + "/notifications/fcmtoken/" + token,
                   method: .put,
                   headers: [
                   "appToken": Config.appToken,
                   "appSecret": Config.appSecret,
                   "accessToken": UserDefaults.standard.string(forKey: "accToken")!
                   ]
        )
        .responseDecodable(of: APIResponce<NoReply>.self){ response in
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
