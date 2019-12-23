//
//  URLManager.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/23.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case production
    case qa
    case staging
    
    var baseURL: String {
        switch self {
        case .production:   return "https://api.test.org/"
        case .qa:           return "https://qa.test.org/"
        case .staging:      return "https://staging.test.org/"
        }
    }
}

enum URLManager {
    case userInfo
}

extension URLManager {
    
    static var baseURL: String {
        #if DEBUG
        return NetworkEnvironment.qa.baseURL
        #else
        return NetworkEnvironment.production.baseURL
        #endif
    }
    
    var path: String {
        switch self {
        case .userInfo:
            return "userInfo"
        }
    }
}
