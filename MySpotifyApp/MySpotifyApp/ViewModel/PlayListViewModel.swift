//
//  PlayListViewModel.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 08/12/24.
//

import Foundation
import UIKit

class PlayListViewModel {
    
    var playListObject : PlaylistEntity?
    var passPlayListName = String()
    var onItemsUpdated: (() -> Void)? // Completion handler for updates
    var trackList = [TrackEntity]() {
        didSet {
            onItemsUpdated?()
        }
    }
    
    func fetchTrackList(){
        trackList = CoreDataManager.shared.fetchTracklists(withName:(UIApplication.shared.delegate as? AppDelegate)?.createdPlayListName ?? "")
        onItemsUpdated?()
    }
}
