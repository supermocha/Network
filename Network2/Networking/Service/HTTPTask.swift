//
//  HTTPTask.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/16.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    
    case request
    
    case requestURL(urlParameters: Parameters)
    
    case requestJSONBody(bodyParameters: Parameters)
    
    case requestURLJSONBody(urlParameters: Parameters, bodyParameters: Parameters)
    
    // case download
    
    // case upload
}
