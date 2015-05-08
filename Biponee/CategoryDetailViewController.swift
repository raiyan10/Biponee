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
    var productDetails : ProductDetail!
    var relatedProducts : NSMutableArray = []
    var productPictures : NSMutableArray = []
    
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
            layout.minimumInteritemSpacing = 2.0 //1000.0
            layout.minimumLineSpacing = 2.0
            //layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        }
        println(layout.itemSize.width)
        
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
        
            let font:UIFont? = UIFont(name: "Avenir Next Condensed", size: 17.0)
        
            let currentPriceText = (self.categoryDetails.objectAtIndex(indexPath.row) as! CategoryDetails).Price
            let oldPriceText = (self.categoryDetails.objectAtIndex(indexPath.row) as! CategoryDetails).OldPrice
        
            var currentPriceAttributedText: NSMutableAttributedString =  NSMutableAttributedString(string: "\(currentPriceText) ")
            currentPriceAttributedText.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, currentPriceAttributedText.length))
            currentPriceAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, currentPriceAttributedText.length))
        
        
            var oldPriceAttributedText: NSMutableAttributedString =  NSMutableAttributedString(string: oldPriceText)
            oldPriceAttributedText.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, oldPriceAttributedText.length))
            oldPriceAttributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, oldPriceAttributedText.length))
            oldPriceAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, oldPriceAttributedText.length))
        
            currentPriceAttributedText.appendAttributedString(oldPriceAttributedText)
        
            cell.priceLabel.attributedText = currentPriceAttributedText
        
            let imageURL = (self.categoryDetails.objectAtIndex(indexPath.row) as! CategoryDetails).ImageUrl
        
            cell.catImageView.image = nil
            cell.request?.cancel()
        
            cell.request = Alamofire.request(.GET, imageURL).responseImage() {
                (request, _, image, error) in
                
                if error == nil && image != nil
                {
                    cell.catImageView.image = image
                }
                
                if (self.categoryDetails.objectAtIndex(indexPath.row) as! CategoryDetails).AvailableForPreOrder == true
                {
                    cell.soldOutImageView.hidden = false;
                }
                else
                {
                    cell.soldOutImageView.hidden = true;
                }
            }
        
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let productId = (self.categoryDetails.objectAtIndex(indexPath.row) as! CategoryDetails).Id
        
        Alamofire.request(Biponee.Router.ProductDetail(productId)).validate().responseJSON()
        {
            (_, _, JSON, error) in
                
            //println(JSON)
            if error == nil
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
                {
                    let productJSON = JSON  as! NSDictionary
                    self.productDetails = ProductDetail(name: productJSON["Name"] as! String, shortDesc: productJSON["ShortDescription"] as! String, fullDesc: productJSON["FullDescription"] as! String, productPrice: productJSON["ProductPrice"]!, productManufacturer: productJSON["ProductManufacturers"]!)
                    
                    let associatedProducts = (productJSON["AssociatedProducts"] as! [NSDictionary]).map { AssociatedProducts(JSON: $0) }
                    self.relatedProducts = NSMutableArray(array: associatedProducts)
                    
                    let pictureModels = (productJSON["PictureModels"] as! [NSDictionary]).map { PictureModel(JSON: $0) }
                    self.productPictures = NSMutableArray(array: pictureModels)
                    
                    dispatch_async(dispatch_get_main_queue())
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let prodDetailViewCon = storyboard.instantiateViewControllerWithIdentifier("prodDetailViewCon") as! ProductDetailViewController
                        prodDetailViewCon.productDetails = self.productDetails
                        prodDetailViewCon.relatedProducts = self.relatedProducts
                        prodDetailViewCon.pictureModels = self.productPictures
                                
                        self.navigationController!.pushViewController(prodDetailViewCon, animated: true)
                    }
                }
            }
            else
            {
                println("Error: \(error!.localizedDescription)")
            }
        }
    }
}


