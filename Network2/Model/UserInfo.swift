//
//  UserInfo.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/20.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

class UserInfo {
    
    /// Data type of request url path
    struct URLInput: Codable {
        var id: String
    }
    
    /// Data type of request
    struct Input: Codable {
        var userID: Int
        var userPassword: String
    }
    
    /// Data type of response
    struct Output: Codable {
        var name: String
        var gender: Int
    }
}

extension UserInfo.Input {
    
    private enum CodingKeys: String, CodingKey {
        case userID         = "user_id"
        case userPassword   = "user_password"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try container.decode(Int.self, forKey: .userID)
        userPassword = try container.decode(String.self, forKey: .userPassword)
    }
}

extension UserInfo.Output {

    private enum CodingKeys: String, CodingKey {
        case name   = "name"
        case gender = "gender"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        gender = try container.decode(Int.self, forKey: .gender)
    }
}
