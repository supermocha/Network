//
//  NetworkResponse.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/20.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

enum Result<String> {
    case success
    case failure(String)
}

enum NetworkResponse: String {
    case success
    case authenticationError    = "You need to be authenticated first."
    case badRequest             = "Bad request"
    case outdated               = "The url you requested is outdated."
    case failed                 = "Network request failed."
    case noData                 = "Response returned with no data to decode."
    case unableToDecode         = "We could not decode the response."
}

enum NetworkError: String, Error {
    case parametersNil  = "Parameters is nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL     = "URL is nil."
    case taskNil        = "Task is nil."
}
