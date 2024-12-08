//
//  CreatePlayListViewController.swift
//  MySpotifyApp
//
//  Created by Hardik Bhalgamiya on 07/12/24.
//

import Foundation
import UIKit


class CreatePlayListViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var playlistTextfield: UITextField!
    
    //MARK: Variables
    var dismissCompletion: (() -> Void)? // Completion handler for dismissal
    var createPlayListViewModel = CreatePlayListViewModel()

    //MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistTextfield.becomeFirstResponder()
        
    }
    
    //MARK: Button Action methods
    @IBAction func confirmButtonActionClick(_ sender: Any) {
        if playlistTextfield.text?.isEmpty == false {
            createPlayListViewModel.savePlayList(name: playlistTextfield.text ?? "" )
            dismiss(animated: false) {
                (UIApplication.shared.delegate as? AppDelegate)?.createdPlayListName = self.playlistTextfield.text ?? ""
                self.dismissCompletion?()
            }
        }
    }
}

//MARK: Textfield delegates
extension CreatePlayListViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        playlistTextfield.endEditing(true)
        return true
    }
}
