//
//  ResponseProtocol.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/20.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

public protocol ResponseProtocol {
    associatedtype Response
    static func parse(jsonData: Data) throws -> Response
}
