//
//  EncodableExtension.swift
//  Network2
//
//  Created by Cheryl Chen on 2019/12/20.
//  Copyright © 2019 Cheryl Chen. All rights reserved.
//

import Foundation

extension Encodable {

    /// Convert struct to dictionary
    func dictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw NSError()
      }
      return dictionary
    }
}
