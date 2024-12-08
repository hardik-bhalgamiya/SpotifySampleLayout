//
//  CoreDataManager.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 08/12/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    // MARK: - Singleton
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MySpotifyApp") // Replace with your .xcdatamodeld file name
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    // MARK: - Contexts
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    // MARK: - Save Context
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
extension CoreDataManager {
    func createPlaylist(name: String) {
        let playlist = PlaylistEntity(context: viewContext)
        playlist.name = name
        saveContext()
    }
    func addTrackToPlaylist(playlist: String, trackName: String, artistName: String, imageURL: String) {
        let track = TrackEntity(context: viewContext)
        track.trackName = trackName
        track.artistName = artistName
        track.playListName = playlist
        track.trackImage = imageURL
        saveContext()
    }
    func fetchPlaylists() -> [PlaylistEntity] {
        let fetchRequest: NSFetchRequest<PlaylistEntity> = PlaylistEntity.fetchRequest()
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch playlists: \(error)")
            return []
        }
    }
    
    func fetchTracklists(withName name: String) -> [TrackEntity] {
        // Access the Core Data context
        
        // Create a fetch request for the Playlist entity
        let fetchRequest: NSFetchRequest<TrackEntity> = TrackEntity.fetchRequest()
        
        // Add a predicate to filter by the `name` attribute
        fetchRequest.predicate = NSPredicate(format: "playListName == %@", name)
        
        do {
            // Perform the fetch
            let playlists = try viewContext.fetch(fetchRequest)
            return playlists
        } catch {
            print("Failed to fetch playlists: \(error)")
            return []
        }
    }
    
}
