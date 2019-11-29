//
//  SearchResponse.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 29/11/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation

struct SearchResponse : Codable {
    let album: [Album]?
}
