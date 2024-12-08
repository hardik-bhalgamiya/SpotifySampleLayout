//
//  ImageGridHelper.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 09/12/24.
//

import Foundation
import UIKit
import SDWebImage

class ImageGridHelper {
    static private var imageCache = NSCache<NSString, UIImage>()
    
    /// Loads and combines images into a grid for the given URLs.
    /// - Parameters:
    ///   - urls: Array of image URLs.
    ///   - targetSize: The size of the final grid image.
    ///   - completion: Completion handler with the resulting image.
    static func loadAndCombineImages(
        from urls: [URL],
        targetSize: CGSize,
        completion: @escaping (UIImage?) -> Void
    ) {
        let cacheKey = urls.map(\.absoluteString).joined(separator: "-") as NSString
        
        // Check if the combined image is already cached
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        var images: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for url in urls {
            dispatchGroup.enter()
            SDWebImageDownloader.shared.downloadImage(with: url) { image, _, _, _ in
                if let image = image {
                    images.append(image)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let combinedImage = createGridImage(from: images, targetSize: targetSize)
            if let combinedImage = combinedImage {
                imageCache.setObject(combinedImage, forKey: cacheKey)
            }
            completion(combinedImage)
        }
    }
    
    /// Combines images into a grid.
    private static func createGridImage(from images: [UIImage], targetSize: CGSize) -> UIImage? {
        guard !images.isEmpty else { return nil }
        
        let count = images.count
        let columns = count == 2 ? 2 : Int(ceil(sqrt(Double(count))))
        let rows = Int(ceil(Double(count) / Double(columns)))
        
        let cellWidth = targetSize.width / CGFloat(columns)
        let cellHeight = targetSize.height / CGFloat(rows)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        for (index, image) in images.enumerated() {
            let row = index / columns
            let col = index % columns
            let rect = CGRect(x: CGFloat(col) * cellWidth, y: CGFloat(row) * cellHeight, width: cellWidth, height: cellHeight)
            image.draw(in: rect)
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
}

