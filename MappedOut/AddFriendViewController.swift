//
//  AddFriendViewController.swift
//  MappedOut
//
//  Created by Thomas Clifford on 3/31/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse

class AddFriendViewController: UIViewController, UISearchBarDelegate{

    let searchBar = UISearchBar()
    
    @IBOutlet weak var resultsPicture: UIImageView!
    @IBOutlet weak var resultName: UILabel!
    @IBOutlet weak var resultUsername: UILabel!
    @IBOutlet weak var resultStatusIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

      
        self.searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        self.searchBar.frame.size.width = self.view.frame.size.width
        self.searchBar.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print("begin")
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("change")
        
        User.getUserByUsername(searchText) { (user: User?) -> () in
            if let user = user {
                self.resultUsername.text = "@\(user.username!)"
                self.resultName.text = user.name
                self.resultsPicture.image = user.propic
                
                let friendsArray = User().friendIDs
                var bool = false
                let userId = user.objectId!
                print(userId)
                
                if let friendsArray = friendsArray{
                    for id in friendsArray {
                        if(id == userId) {
                            bool = true
                            break
                        }
                    }   
                }
                
                
                if(bool) {
                    self.resultStatusIcon.image = UIImage(named: "check")
                }
                else {
                    self.resultStatusIcon.image = UIImage(named: "plus")
                }
                
                
                
            }
            else {
                self.resultUsername.text = "No Users"
                self.resultStatusIcon.image = UIImage(named: "blank")
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
