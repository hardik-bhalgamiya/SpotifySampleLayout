//
//  SearchPlayListViewController.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 08/12/24.
//

import UIKit
import CoreData
import SDWebImage

class SearchPlayListViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var searchBarTextFiled: UITextField!
    @IBOutlet var searchListTableView : UITableView! {
        didSet{
            self.searchListTableView.register(UINib(nibName: "SearchPlayListTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchPlayListTableViewCell")
            self.searchListTableView.sectionHeaderHeight = UITableView.automaticDimension
            self.searchListTableView.estimatedSectionHeaderHeight = 36
            self.searchListTableView.contentInsetAdjustmentBehavior = .never
            
        }
    }
    
    //MARK: Variables
    private let viewModel = SearchViewModel()
    var searchPlayListViewModel = SearchPlayListViewModel()
    private var searchResults = [SearchResult]()
    weak var searchDelegateCall : searchProtolcol?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupBindings()
    }
    
    //MARK: Other Function
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] results in
            self?.searchResults = results
            self?.searchListTableView.reloadData()
        }
    }
    
    private func setupTableView() {
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
    }
    
    private func setupSearchBar() {
        searchBarTextFiled.delegate = self
    }
    
    
    //MARK: Button Action Methods
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        searchDelegateCall?.reloadFromSearch()
    }
    
}
//MARKL: SearchBar Delegate Extension
extension SearchPlayListViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            viewModel.search(query: text)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
}


// MARK: UITableView Delegate and DataSource
extension SearchPlayListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPlayListTableViewCell", for: indexPath) as! SearchPlayListTableViewCell
        cell.selectionStyle = .none
        let result = searchResults[indexPath.row]
        cell.nameLabel?.text = result.trackName
        cell.descriptionLabel.text = result.artistName
        cell.addToPlayList.tag = indexPath.row
        cell.addToPlayList.addTarget(self, action: #selector(SearchPlayListViewController.addToPlayList(sender:)), for: .touchUpInside)
        if let imageUrl = URL(string: "\(result.artworkUrl60 ?? "")") {
            cell.iconImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""), options: .refreshCached) { image, error, cacheType, url in
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    @objc func addToPlayList(sender:UIButton){
        print(sender.tag)
        let result = searchResults[sender.tag]
        searchPlayListViewModel.addTrackOnPlayList(trackEntityObj: result)
    }
}
