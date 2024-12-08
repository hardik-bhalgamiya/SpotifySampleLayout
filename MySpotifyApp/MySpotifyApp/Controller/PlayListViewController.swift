//
//  PlayListViewController.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 07/12/24.
//

import UIKit

protocol searchProtolcol : AnyObject {
    func reloadFromSearch()
}

class PlayListViewController: UIViewController , searchProtolcol{
    
    //MARK: IBOutlets
    @IBOutlet var playListTableView : UITableView! {
        didSet{
            self.playListTableView.register(UINib(nibName: "PlayListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayListTableViewCell")
            self.playListTableView.sectionHeaderHeight = UITableView.automaticDimension
            self.playListTableView.estimatedSectionHeaderHeight = 36
            self.playListTableView.contentInsetAdjustmentBehavior = .never
            
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: Variables
    var playListViewModel = PlayListViewModel()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    //MARK: Button action methods
    @IBAction func backButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusButtonClick(_ sender: Any) {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "SearchPlayListViewController") as! SearchPlayListViewController
        nextVC.searchPlayListViewModel.playListEntity = playListViewModel.playListObject
        nextVC.searchDelegateCall = self
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    func reloadFromSearch() {
        playListViewModel.fetchTrackList()
        self.descriptionLabel.text = "\(self.playListViewModel.trackList.count) Songs"
        
    }
    
    //MARK: SetData Method
    func setData(){
        nameLabel.text = (UIApplication.shared.delegate as? AppDelegate)?.createdPlayListName ?? ""
        reloadFromSearch()
        playListViewModel.onItemsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.descriptionLabel.text = "\(self?.playListViewModel.trackList.count ?? 0) Songs"
                self?.playListTableView.reloadData()
            }
        }
    }
    
    
}
// MARK:  UITableView Delegate 
extension PlayListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playListViewModel.trackList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListTableViewCell", for: indexPath) as! PlayListTableViewCell
        cell.selectionStyle = .none
        
        let currentTrackList = playListViewModel.trackList[indexPath.row]
        cell.nameLabel.text = currentTrackList.trackName
        cell.descriptionLabel.text = currentTrackList.artistName
        if let imageUrl = URL(string: "\(currentTrackList.trackImage ?? "")") {
            cell.iconImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(), options: .refreshCached) { image, error, cacheType, url in
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
