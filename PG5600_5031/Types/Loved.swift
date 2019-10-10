//
//  Loved.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 10/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation

// The api where we fetch the ablbums wraps all the albums in an array that is called "loved"
struct LovedResponse: Codable {
    let loved: [Album]
}
