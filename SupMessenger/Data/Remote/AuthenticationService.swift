//
//  AuthenticationService.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//

import Foundation
import Alamofire

struct AuthenticationService{
    static let shared = AuthenticationService()
    
    func login(data: AuthenticationRequest, callback: @escaping(APIResponce<AuthLoginResponce>?, Error?) -> ()){
        AF.request(Config.url + "/authentication/",
                   method: .put,
                   parameters: data,
                   headers: [
                   "appToken": Config.appToken,
                   "appSecret": Config.appSecret
                   ]
        )
        .responseDecodable(of: APIResponce<AuthLoginResponce>.self){ response in
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
