//
//  loginViewController.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/3/8.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit
import Parse
import TKSubmitTransition
import SwiftyDrop
import Foundation

class loginViewController: UIViewController,UIViewControllerTransitioningDelegate {

    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var UsernameField: UITextField!
    
    var Signinbutton: TKTransitionSubmitButton!
    var Signupbutton: TKTransitionSubmitButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Signinbutton = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        Signinbutton.center = CGPoint(x: self.view.bounds.width / 2,
            y: self.view.bounds.height-200)
        //Signinbutton.center = self.view.center
        //Signinbutton.bottom = self.view.frame.height - 60
        Signinbutton.setTitle("Sign in", forState: .Normal)
        Signinbutton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        Signinbutton.addTarget(self, action: "buttononSignin:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(Signinbutton)
        
        Signupbutton = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        Signupbutton.center = CGPoint(x: self.view.bounds.width / 2,
            y: self.view.bounds.height-130)
        //btn.center = self.view.center
        //btn.bottom = self.view.frame.height - 60
        Signupbutton.setTitle("Sign up", forState: .Normal)
        Signupbutton.normalBackgroundColor = UIColor(red:0.51, green:0.84, blue:1.00, alpha:1.0)
        Signupbutton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        Signupbutton.addTarget(self, action: "buttononSignup:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(Signupbutton)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        Signinbutton.hidden = false
        Signupbutton.hidden = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttononSignin(button: TKTransitionSubmitButton) {
        Signinbutton.startLoadingAnimation()
        PFUser.logInWithUsernameInBackground(UsernameField.text!, password: PasswordField.text!) { (user:PFUser?, error:NSError?) -> Void in
            if(user != nil){
                
                print("you are logged in")
                self.Signupbutton.hidden = true
                self.Signinbutton.startFinishAnimation(0.6, completion: { () -> () in
                    let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CoreViewController")
                    
                    secondVC.transitioningDelegate = self
                    
                    self.presentViewController(secondVC, animated: true, completion: nil)
                })
                NSTimer.schedule(delay: 1) { timer in
                    Drop.down("Sign in successfully", state: .Success, duration: 4, action: nil)
                }
                
                
            }else{
                button.failedAnimation(0, completion: nil)
                Drop.down("\(error!.localizedDescription)", state: .Warning, duration: 4, action: nil)
            }
        }
    }
    
    @IBAction func buttononSignup(button:TKTransitionSubmitButton) {
        let newUser = PFUser()
        
        newUser.username = UsernameField.text
        newUser.password = PasswordField.text
        
        Signupbutton.startLoadingAnimation()
        newUser.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if(success){
                print("created new user")
                self.Signinbutton.hidden = true
                self.Signupbutton.startFinishAnimation(0.6, completion: { () -> () in
                    
                    
                    let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CoreViewController")
                    secondVC.transitioningDelegate = self
                    Drop.down("Sign up successfully", state: .Success, duration: 4, action: nil)
                    self.presentViewController(secondVC, animated: true, completion: nil)
                })
            }else{
                print(error?.localizedDescription)
                button.failedAnimation(0, completion: nil)
                Drop.down("\(error!.localizedDescription)", state: .Warning, duration: 4, action: nil)
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
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fadeInAnimator = TKFadeInAnimator()
        return fadeInAnimator
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

}
