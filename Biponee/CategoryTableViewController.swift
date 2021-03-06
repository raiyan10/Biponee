//
//  CategoryTableViewController.swift
//  Biponee
//
//  Created by Masudur Rahman on 4/29/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit
import Alamofire

class CategoryTableViewController: UITableViewController {

    let cellIdentifier : String = "catCell"
    let headerIdentifier : String = "headerCell"
    
    var productCategories : NSMutableArray = []
    var headerTitle : String = ""
    
    var catDetails = NSMutableArray()
    
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
        return self.productCategories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CategoryTableViewCell

        // Configure the cell...
        cell.titleLabel.text = (self.productCategories.objectAtIndex(indexPath.row) as! Category).Name
        cell.closureImageView.hidden = false

        return cell
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
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCellWithIdentifier(headerIdentifier) as! HeaderTableViewCell
        
        // Configure the header...
        headerView.titleLabel.text = headerTitle
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CategoryTableViewCell
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let catId = (self.productCategories.objectAtIndex(indexPath.row) as! Category).Id
        
        let subCategories = (Biponee.rootCategories  as! [NSDictionary]).filter({ ($0["ParentCategoryId"] as! Int) == catId }).map { Category(id: $0["Id"] as! Int, name: $0["Name"] as! String, parentId: $0["ParentCategoryId"] as! Int) }
        
        if subCategories.count == 0
        {
            Alamofire.request(Biponee.Router.CategoryDetail(catId)).validate().responseJSON()
            {
                (_, _, JSON, error) in
            
                //println(JSON)
                if error == nil
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
                    {
                        let cat_Detail = (JSON  as! [NSDictionary]).map{ CategoryDetails(JSON: $0) }
                        self.catDetails = NSMutableArray(array: cat_Detail)
                            
                        dispatch_async(dispatch_get_main_queue())
                        {
                            let catDetailNavCon = storyboard.instantiateViewControllerWithIdentifier("catDetailNavCon") as! UINavigationController
                            
                            let catDetailViewCon = catDetailNavCon.childViewControllers[0] as! CategoryDetailViewController
                            catDetailViewCon.navTitle = (self.productCategories.objectAtIndex(indexPath.row) as! Category).Name
                            catDetailViewCon.categoryDetails = self.catDetails
                                
                            self.revealViewController().pushFrontViewController(catDetailNavCon, animated: true)
                        }
                    }
                }
                else
                {
                    println("Error: \(error!.localizedDescription)")
                }
            }
        }
        else
        {
            let catTableViewController = storyboard.instantiateViewControllerWithIdentifier("catTableVC") as! CategoryTableViewController
            catTableViewController.headerTitle = cell.titleLabel.text!
            catTableViewController.productCategories = NSMutableArray(array: subCategories)
            
            self.navigationController!.pushViewController(catTableViewController, animated: true)
        }
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
