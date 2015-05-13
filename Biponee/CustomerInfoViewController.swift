//
//  CustomerInfoViewController.swift
//  Biponee
//
//  Created by Masudur Rahman on 5/13/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit

class CustomerInfoViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var containerView: UIView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var newsLetterSwitch: UISwitch!
    @IBOutlet var saveButton: UIButton!
    
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
        
        self.saveButton.layer.cornerRadius = 4.0
        self.saveButton.layer.borderWidth = 1.0
        self.saveButton.layer.borderColor = UIColor.orangeColor().CGColor
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
    
    @IBAction func feedNewsLetter(sender: AnyObject)
    {
        
    }

    @IBAction func saveInfo(sender: AnyObject)
    {
        
    }
}
