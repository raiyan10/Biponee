//
//  CategoryDetailViewController.swift
//  Biponee
//
//  Created by Masudur Rahman on 5/4/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit
import Alamofire

class CategoryDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var navTitle : String = ""
    var categoryDetails : NSMutableArray = []
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    let categoryCellIdentifier = "catCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.navTitle
        println(self.categoryDetails.count)
        
        if self.revealViewController() != nil
        {
            self.revealViewController().rearViewRevealWidth = 300
            
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLayout()
    {
        let layout = UICollectionViewFlowLayout()
        
        let itemWidth:CGFloat
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            itemWidth = (view.bounds.size.width - 12) / 3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 70)
            layout.minimumInteritemSpacing = 2.0
            layout.minimumLineSpacing = 2.0
        }
        else
        {
            itemWidth = (view.bounds.size.width - 10) / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 50)
            layout.minimumInteritemSpacing = 2.0
            layout.minimumLineSpacing = 2.0
        }
        
        self.categoryCollectionView.collectionViewLayout = layout
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: CollectionView
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
            return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
            return self.categoryDetails.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) ->
        UICollectionViewCell
    {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(categoryCellIdentifier,
            forIndexPath: indexPath) as! CategoryCollectionViewCell
            
            // Configure the cell
            cell.layer.borderWidth = 1.0
            cell.layer.cornerRadius = 4.0
            cell.layer.borderColor = UIColor.grayColor().CGColor
        
            cell.nameLabel.text = (self.categoryDetails.objectAtIndex(indexPath.row) as! CategoryDetails).Name
            cell.shortDescLabel.text = (self.categoryDetails.objectAtIndex(indexPath.row) as! CategoryDetails).ShortDescription
            cell.priceLabel.text = (self.categoryDetails.objectAtIndex(indexPath.row) as! CategoryDetails).Price
        
            let imageURL = (self.categoryDetails.objectAtIndex(indexPath.row) as! CategoryDetails).ImageUrl
        
            cell.catImageView.image = nil
            cell.request?.cancel()
        
            cell.request = Alamofire.request(.GET, imageURL).responseImage() {
                (request, _, image, error) in
                if error == nil && image != nil {
                    cell.catImageView.image = image
                }
            }
        
            return cell
    }
}
