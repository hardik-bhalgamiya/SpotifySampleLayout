//
//  CreatePlayListViewModel.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 08/12/24.
//

import Foundation

class CreatePlayListViewModel {
    func savePlayList(name:String){
        CoreDataManager.shared.createPlaylist(name: name)
        CoreDataManager.shared.saveContext()
    }
}
