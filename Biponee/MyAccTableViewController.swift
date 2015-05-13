//
//  MyAccTableViewController.swift
//  Biponee
//
//  Created by Masudur Rahman on 5/13/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit

class MyAccTableViewController: UITableViewController {
    
    let cellIdentifier : String = "myAccCell"
    let headerIdentifier : String = "headerCell"
    let headerTitle : String = "My Account"
    
    let accountOptions = ["Customer Info", "Addresses", "Orders", "Bonus", "Change Password"]
    let accountImages = ["customer.png", "address.png", "orders.png", "bonus.png", "changePass.png"]
    
    let navConIdentifiers = ["customerInfoNavCon", "", "", "", "changePassNavCon"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.accountOptions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MyAccTableViewCell
        
        // Configure the cell...
        cell.titleLabel.text = self.accountOptions[indexPath.row]
        cell.myAccImageView.image = UIImage(named: self.accountImages[indexPath.row]);
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCellWithIdentifier(headerIdentifier) as! HeaderTableViewCell
        
        // Configure the header...
        headerView.titleLabel.text = headerTitle
        
        return headerView
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAccNavCon = storyboard.instantiateViewControllerWithIdentifier(navConIdentifiers[indexPath.row]) as! UINavigationController
        let myAccViewCon: AnyObject = myAccNavCon.childViewControllers[0]
        self.revealViewController().pushFrontViewController(myAccNavCon, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
