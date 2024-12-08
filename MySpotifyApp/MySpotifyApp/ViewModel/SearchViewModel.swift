//
//  SearchViewModel.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 08/12/24.
//

import Foundation

class SearchViewModel {
    private var dataTask: URLSessionDataTask?
    private var debounceTimer: Timer?
    var onDataUpdated: (([SearchResult]) -> Void)?
    
    func search(query: String) {
        // Cancel any ongoing request
        dataTask?.cancel()
        
        // If the query is empty, clear the results
        guard !query.isEmpty else {
            onDataUpdated?([])
            return
        }
        // Debounce the API call
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.performSearch(query: query)
        }
    }
    
    private func performSearch(query: String) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(query)&limit=20") else { return }
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching search results: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.onDataUpdated?(apiResponse.results)
                }
            } catch {
                print("Error decoding search results: \(error.localizedDescription)")
            }
        }
        dataTask?.resume()
    }
}
