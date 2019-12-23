//
//  ParameterEncoding.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/16.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

protocol ParameterEncoder {
    func encode(request: inout URLRequest, with parameters: Parameters) throws
}

public enum ParameterEncoding {
    case urlEncoding
    case jsonBodyEncoding
    case urlJSONBodyEncoding
}

extension ParameterEncoding {
    
    func encode(request: inout URLRequest,
                urlParameters: Parameters?,
                bodyParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(request: &request, with: urlParameters)
                
            case .jsonBodyEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(request: &request, with: bodyParameters)
                
            case .urlJSONBodyEncoding:
                guard let bodyParameters = bodyParameters, let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(request: &request, with: urlParameters)
                try JSONParameterEncoder().encode(request: &request, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}
