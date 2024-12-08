//
//  SearchModel.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 08/12/24.
//

import Foundation

struct SearchResult: Codable {
    let trackName: String?
    let artistName: String?
    let artworkUrl60 : String?
}

struct APIResponse: Codable {
    let results: [SearchResult]
}

