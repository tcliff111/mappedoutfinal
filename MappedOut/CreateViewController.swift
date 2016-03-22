//
//  CreateViewController.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/3/19.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        closeButton.layer.cornerRadius = 25
        //closeButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
