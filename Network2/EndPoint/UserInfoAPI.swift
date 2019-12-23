//
//  UserInfoAPI.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/20.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

class UserInfoRequest: RequestProtocol {
    
    static var baseURL = URLManager.baseURL
    
    static var path = URLManager.userInfo.path
    
    static var httpHeaders: HTTPHeaders? = nil
    
    static var httpMethod = HTTPMethod.get

    static func task(with urlParameters: UserInfo.URLInput?, bodyParameters: UserInfo.Input?) -> HTTPTask {
        do {
            return .requestURL(urlParameters: try urlParameters.dictionary())
        } catch(let error) {
            print(error.localizedDescription)
        }
        return .request
    }
}

class UserInfoResponse: ResponseProtocol {

    static func parse(jsonData: Data) throws -> UserInfo.Output {
        do {
            let output = try JSONDecoder().decode(UserInfo.Output.self, from: jsonData)
            return output
        } catch {
            print("Failed to decode \(self) json, error \(error.localizedDescription)")
            throw error
        }
    }
}
