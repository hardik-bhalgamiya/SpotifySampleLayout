//
//  LibraryCustomCollectionViewCell.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 07/12/24.
//

import UIKit

class LibraryCustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var isGridView: Bool = true {
        didSet {
            updateLayout()
        }
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configureUI()
    }
    override func prepareForReuse() {
            super.prepareForReuse()
        iconImageView.image = nil // Clear the image for reuse
    }
    
    private func configureUI() {
        // Initial setup
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        //iconImageView.contentMode = .scaleAspectFill
        //iconImageView.layer.cornerRadius = 8
        //iconImageView.clipsToBounds = true
        
        
    }
    func setDataBasedOnTrackList(objModel:PlaylistEntity?){
        let trackArray = CoreDataManager.shared.fetchTracklists(withName: objModel?.name ?? "")
        self.nameLabel.text = objModel?.name
        self.descriptionLabel.text = "Playlist \(trackArray.count) Songs"
      
        var imageArray = [URL]()

        for i in trackArray {
            if imageArray.count <= 4 {
                imageArray.append(URL(string: i.trackImage ?? "") ?? URL(fileURLWithPath: ""))
            }
        }
        
        
        // Load and display images
        ImageGridHelper.loadAndCombineImages(from: imageArray, targetSize: self.iconImageView.bounds.size) { [weak self] combinedImage in
            guard let self = self else { return }
            self.iconImageView.image = combinedImage
        }
        
        
    }
    
    
    
    private func updateLayout() {
        if isGridView {
            // Grid View: Vertical layout
            stackView.axis = .vertical
            stackView.alignment = .leading
         //   self.iconImageView.contentMode = .scaleAspectFill
        } else {
            // List View: Horizontal layout
            stackView.axis = .horizontal
            stackView.alignment = .leading
            
        }
    }
}
