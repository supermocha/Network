//
//  JSONParameterEncoder.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/16.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoder {
    
    func encode(request: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
