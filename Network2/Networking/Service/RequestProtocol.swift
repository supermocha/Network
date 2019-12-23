//
//  EndPointType.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/16.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

public protocol RequestProtocol {
    associatedtype URLParameters
    associatedtype BodyParameters
    static var baseURL: String { get }
    static var path: String { get }
    static var httpHeaders: HTTPHeaders? { get }
    static var httpMethod: HTTPMethod { get }
    static func task(with urlParameters: URLParameters?, bodyParameters: BodyParameters?) -> HTTPTask
}
