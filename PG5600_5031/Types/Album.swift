//
//  Album.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 10/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation

// Details about a given album
struct Album: Codable {
    let idAlbum: String
    let idArtist: String
    let idLabel: String?
    let strAlbum: String
    let strAlbumStripped: String
    let strArtist: String
    let strArtistStripped: String
    let intYearReleased: String
    let strStyle: String?
    let strGenre: String?
    let strLabel: String?
    let strReleaseFormat: String
    let intSales: String?
    let strAlbumThumb: String?
    let strAlbumThumbHQ: String?
    let strAlbumThumbBack: String?
    let strAlbumCDart: String?
    let strAlbumSpine: String?
    let strAlbum3DCase: String?
    let strAlbum3DFlat: String?
    let strAlbum3DFace: String?
    let strAlbum3DThumb: String?
    let strDescription: String?
    let strDescriptionDE: String?
    let strDescriptionFR: String?
    let strDescriptionCN: String?
    let strDescriptionIT: String?
    let strDescriptionJP: String?
    let strDescriptionRU: String?
    let strDescriptionES: String?
    let strDescriptionPT: String?
    let strDescriptionSE: String?
    let strDescriptionNL: String?
    let strDescriptionHU: String?
    let strDescriptionNO: String?
    let strDescriptionIL: String?
    let strDescriptionPL: String?
    let intLoved: String?
    let intScore: String?
    let intScoreVotes: String?
    let strReview: String?
    let strMood: String?
    let strTheme: String?
    let strSpeed: String?
    let strLocation: String?
    let strMusicBrainzID: String
    let strMusicBrainzArtistID: String
    let strAllMusicID: String?
    let strBBCReviewID: String?
    let strRateYourMusicID: String?
    let strDiscogsID: String?
    let strWikidataID: String?
    let strWikipediaID: String?
    let strGeniusID: String?
    let strLyricWikiID: String?
    let strMusicMozID: String?
    let strItunesID: String?
    let strAmazonID: String?
    let strLocked: String?
}
