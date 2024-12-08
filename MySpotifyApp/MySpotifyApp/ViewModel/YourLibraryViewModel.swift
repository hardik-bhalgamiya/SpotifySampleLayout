//
//  YourLibraryViewModel.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 08/12/24.
//

import Foundation

class YourLibraryViewModel {
    var allPlayList = [PlaylistEntity](){
        didSet {
            onItemsUpdated?()
        }
    }
    
    var onItemsUpdated: (() -> Void)? // Completion handler for updates

    init(){
        fetchAllPlayList()
    }
    
    func fetchAllPlayList(){
        let playlists = CoreDataManager.shared.fetchPlaylists()
        if playlists.count > 0 {
            allPlayList = playlists
        }
    }
}
