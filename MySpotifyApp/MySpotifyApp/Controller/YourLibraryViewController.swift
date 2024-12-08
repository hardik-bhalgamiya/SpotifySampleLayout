//
//  YourLibraryViewController.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 07/12/24.
//

import UIKit

class YourLibraryViewController: UIViewController {
    
    @IBOutlet weak var createPlaylistView: UIView!
    
    
    @IBOutlet weak var playlistLableContainerView: UIView!
    
    
    @IBOutlet weak var containerViewForCollection: UIView!
    private var collectionView: UICollectionView!
    private var isGridView = true
    
    
    var yourLibraryViewModel = YourLibraryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistLableContainerView.layer.cornerRadius = 16
        playlistLableContainerView.layer.borderWidth = 0.5
        playlistLableContainerView.layer.borderColor = UIColor.darkGray.cgColor
        
        
        // Do any additional setup after loading the view.
        // Initialize Collection View
        let layout = createGridLayout()
        collectionView = UICollectionView(frame: containerViewForCollection.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        containerViewForCollection.addSubview(collectionView)
        
        // Register Custom Cell
        let nib = UINib(nibName: "LibraryCustomCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "LibraryCustomCollectionViewCell")
        
        yourLibraryViewModel.onItemsUpdated = { [weak self] in
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        yourLibraryViewModel.fetchAllPlayList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.createPlaylistView.isHidden = true
    }
     
    
    // MARK: - Layouts
    private func createGridLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let totalSpacing: CGFloat = 30 // Adjust this based on section insets and item spacing
        let itemWidth = (containerViewForCollection.bounds.width - totalSpacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }
    
    private func createListLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: containerViewForCollection.bounds.width - 20, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        return layout
    }
    
    @IBAction func ToggleGridActionButton(_ sender: Any) {
       
        
        isGridView.toggle()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData() // Refresh cells to adjust layout

            // Create a new layout based on the current view mode
            let newLayout = UICollectionViewFlowLayout()
            if isGridView {
                let width = containerViewForCollection.bounds.width / 2 - 15
                newLayout.itemSize = CGSize(width: width, height: width) // Grid: Square cells
            } else {
                newLayout.itemSize = CGSize(width: containerViewForCollection.bounds.width - 20, height: 100) // List: Wider cells
            }
            newLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            newLayout.minimumLineSpacing = 10
            newLayout.minimumInteritemSpacing = 10
            
            // Animate layout change
            UIView.animate(withDuration: 0.3) {
                self.collectionView.setCollectionViewLayout(newLayout, animated: true)
            }


    }
   
    @IBAction func plusButtonClick(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        UIView.transition(with: self.createPlaylistView , duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                                self.createPlaylistView.isHidden = false
                      })
        
    }
    
    @IBAction func presentViewActionClick(_ sender: Any) {
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "CreatePlayListViewController") as! CreatePlayListViewController
            let navController = UINavigationController(rootViewController: presentedVC)
        navController.navigationBar.isHidden = true
        
        
        presentedVC.dismissCompletion = { [weak self] in
                    // Navigate to another view controller after dismissing
            let nextVC = self?.storyboard!.instantiateViewController(withIdentifier: "PlayListViewController") as! PlayListViewController
            nextVC.playListViewModel.passPlayListName = ""
            
            
            self?.navigationController?.pushViewController(nextVC, animated: false)
                }
        self.present(navController, animated: true, completion: nil)
        
    }
    
}
// MARK: - UICollectionViewDataSource

extension YourLibraryViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yourLibraryViewModel.allPlayList.count // Example items count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCustomCollectionViewCell", for: indexPath) as! LibraryCustomCollectionViewCell
            
            let listObject =  yourLibraryViewModel.allPlayList[indexPath.row]
            cell.setDataBasedOnTrackList(objModel: listObject)
            cell.isGridView = isGridView
            return cell
        }
        
        // MARK: - UICollectionViewDelegateFlowLayout
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if isGridView {
                        let width = containerViewForCollection.bounds.width / 2 - 15
                        return CGSize(width: width, height: width)
                    } else {
                        return CGSize(width: containerViewForCollection.bounds.width - 20, height: 100)
                    }
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listObject =  yourLibraryViewModel.allPlayList[indexPath.item]
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "PlayListViewController") as! PlayListViewController
        nextVC.playListViewModel.playListObject = listObject
        nextVC.playListViewModel.passPlayListName = listObject.name ?? ""
        (UIApplication.shared.delegate as? AppDelegate)?.createdPlayListName = listObject.name ?? ""
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
}
