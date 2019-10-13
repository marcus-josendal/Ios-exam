//
//  Track.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 13/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

struct Track : Codable {
    let idTrack: String
    let idAlbum: String
    let idArtist: String
    let strTrack: String
    let strAlbum: String
    let strArtist: String
    let strArtistAlternate: String?
    let intDuration: String
}
