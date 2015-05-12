//
//  LoginViewController.swift
//  Biponee
//
//  Created by Masudur Rahman on 5/8/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var containerView: UIView!
    @IBOutlet var fbLoginButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailSwitch: UISwitch!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var createAccButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.revealViewController() != nil
        {
            self.revealViewController().rearViewRevealWidth = 300
            
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.containerView.layer.cornerRadius = 8.0
        self.fbLoginButton.layer.cornerRadius = 8.0
        self.loginButton.layer.cornerRadius = 4.0
        
        self.createAccButton.layer.cornerRadius = 4.0
        self.createAccButton.layer.borderWidth = 1.0
        self.createAccButton.layer.borderColor = UIColor.blackColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func login(sender: AnyObject)
    {
        
    }
    
    @IBAction func loginWithFB(sender: AnyObject)
    {
        if ((FBSDKAccessToken.currentAccessToken()) != nil)
        {
            // User is logged in, do work such as go to next view controller.
            println("Access Token Saved: \(FBSDKAccessToken.currentAccessToken().tokenString)")
            return
        }
        
        var login: FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile", "email"], handler: { (result, error) -> Void in
            
            println("User Logged In")
            
            if (error != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else if result.isCancelled
            {
                // Handle cancellations
            }
            else
            {
                // If you ask for multiple permissions at once, you should check if specific permissions missing
                if result.grantedPermissions.contains("email")
                {
                    // Do work
                }
                
                self.returnUserData()
            }
        })
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if (error != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("Access Token: \(FBSDKAccessToken.currentAccessToken().tokenString)")
                
                println("Fetched User: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")
            }
        })
    }
    
    @IBAction func rememberEmail(sender: AnyObject)
    {
        
    }
    
    @IBAction func forgotPass(sender: AnyObject)
    {
        
    }
    
    @IBAction func createAccount(sender: AnyObject)
    {
        
    }
}
