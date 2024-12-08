//
//  SearchPlayListViewModel.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 08/12/24.
//

import Foundation
import UIKit

class SearchPlayListViewModel {
    var playListEntity : PlaylistEntity?
    
    func addTrackOnPlayList(trackEntityObj:SearchResult){
        CoreDataManager.shared.addTrackToPlaylist(playlist: (playListEntity?.name ?? (UIApplication.shared.delegate as? AppDelegate)?.createdPlayListName) ?? "", trackName: trackEntityObj.trackName ?? "-" , artistName: trackEntityObj.artistName ?? "-", imageURL: trackEntityObj.artworkUrl60 ?? "")
    }
}
