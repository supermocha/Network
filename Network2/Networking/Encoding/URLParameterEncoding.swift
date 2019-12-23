//
//  URLParameterEncoding.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/16.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

struct URLParameterEncoder: ParameterEncoder {
    
    func encode(request: inout URLRequest, with parameters: Parameters) throws {
        guard let url = request.url else { throw NetworkError.missingURL }
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            parameters.isEmpty == false {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let newValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let item = URLQueryItem(name: key, value: newValue)
                components.queryItems?.append(item)
            }
            request.url = components.url
        }
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8",
                             forHTTPHeaderField: "Content-Type")
        }
    }
}
