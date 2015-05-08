//
//  LoginViewController.swift
//  Biponee
//
//  Created by Masudur Rahman on 5/8/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit

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
        self.fbLoginButton.layer.cornerRadius = 4.0
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
    
    @IBAction func rememberEmail(sender: AnyObject)
    {
        
    }
    
    @IBAction func loginWithFB(sender: AnyObject)
    {
        
    }
    
    @IBAction func forgotPass(sender: AnyObject)
    {
        
    }
    
    @IBAction func createAccount(sender: AnyObject)
    {
        
    }
}
