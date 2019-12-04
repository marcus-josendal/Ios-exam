//
//  Recommendation.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 04/12/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation

struct SingleResult: Codable {
    let Name: String
}

struct Similar: Codable {
    let Results: [SingleResult]
    let Info: [SingleResult]
}

struct TasteDiveResponse: Codable {
    let Similar: Similar
}
