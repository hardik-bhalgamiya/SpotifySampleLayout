//
//  AppTabbar.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 07/12/24.
//

import Foundation
import UIKit

class AppTabbar: UITabBarController, UITabBarControllerDelegate {

    // MARK: Variable Declaration
    let normalFont : UIFont = UIFont.systemFont(ofSize: 13.0)
    let selectedFont : UIFont = UIFont.systemFont(ofSize: 13.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabbar()
    }
    
    // MARK: setup Tabbar methods
    func setupTabbar(){
        UITabBar.appearance().tintColor = UIColor.darkGray
        self.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowRadius = 8
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.1
        
        self.selectedIndex = 2
        self.delegate = self
    }
    
    override var selectedIndex: Int {
        didSet {
            guard let selectedViewController = viewControllers?[selectedIndex] else {
                return
            }
            selectedViewController.tabBarItem.setTitleTextAttributes([.font: selectedFont], for: .normal)
        }
    }
    
    override var selectedViewController: UIViewController? {
        didSet {
            guard let viewControllers = viewControllers else {
                return
            }
            
            for viewController in viewControllers {
                if viewController == selectedViewController {
                    viewController.tabBarItem.setTitleTextAttributes([.font: selectedFont], for: .normal)
                } else {
                    viewController.tabBarItem.setTitleTextAttributes([.font: normalFont], for: .normal)
                }
            }
        }
    }

}
