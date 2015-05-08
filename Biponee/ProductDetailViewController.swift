//
//  ProductDetailViewController.swift
//  Biponee
//
//  Created by Masudur Rahman on 5/5/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit
import Alamofire

class ProductDetailViewController: UIViewController, UIWebViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var productDetails : ProductDetail!
    var relatedProducts : NSMutableArray = []
    var pictureModels : NSMutableArray = []
    
    var pageController: UIPageViewController?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var descView: UIView!
    @IBOutlet var pageContainerView: UIView!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var callToOrderButton: UIButton!
    @IBOutlet var relatedItemsCollectionView: UICollectionView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var shortDescLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    let categoryCellIdentifier = "catCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.revealViewController() != nil
        {
            self.revealViewController().rearViewRevealWidth = 300
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.addToCartButton.layer.cornerRadius = 4.0
        
        self.callToOrderButton.layer.cornerRadius = 4.0
        self.callToOrderButton.layer.borderWidth = 1.0
        self.callToOrderButton.layer.borderColor = UIColor.blackColor().CGColor
        
        self.descView.layer.cornerRadius = 8.0
        self.nameLabel.text = self.productDetails.Name
        self.shortDescLabel.text = self.productDetails.ShortDescription
        
        let font:UIFont? = UIFont(name: "Avenir Next Condensed", size: 20.0)
        
        let currentPriceText = self.productDetails.Price
        let oldPriceText = self.productDetails.OldPrice
        
        var currentPriceAttributedText: NSMutableAttributedString =  NSMutableAttributedString(string: "\(currentPriceText) ")
        currentPriceAttributedText.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, currentPriceAttributedText.length))
        currentPriceAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, currentPriceAttributedText.length))
        
        var oldPriceAttributedText: NSMutableAttributedString =  NSMutableAttributedString(string: oldPriceText)
        oldPriceAttributedText.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, oldPriceAttributedText.length))
        oldPriceAttributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, oldPriceAttributedText.length))
        oldPriceAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0, oldPriceAttributedText.length))
        
        currentPriceAttributedText.appendAttributedString(oldPriceAttributedText)
        
        self.priceLabel.attributedText = currentPriceAttributedText
        self.brandLabel.text = self.productDetails.manufacturerName
        
        self.pageContainerView.layer.cornerRadius = 8.0
        
        self.webView.layer.cornerRadius = 8.0
        self.webView.scrollView.layer.cornerRadius = 8.0
        
        var htmlString: String! = self.productDetails.FullDescription
        self.webView.loadHTMLString(htmlString, baseURL: nil)
        
        setUpPageViewController()
        
        self.relatedItemsCollectionView.layer.cornerRadius = 8.0
        setUpCollectionViewLayOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpPageViewController()
    {
        // Create page view controller
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        pageController = storyBoard.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        pageController?.dataSource = self
        pageController?.delegate = self
        
        let startingViewController: ContentViewController = viewControllerAtIndex(0)!
        
        let viewControllers: NSArray = [startingViewController]
        pageController!.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: false,  completion: nil)
        
        // Change the size of page view controller
        pageController!.view.frame = self.pageContainerView.bounds
        pageController!.view.layer.cornerRadius = 8.0
        
        self.addChildViewController(pageController!)
        self.pageContainerView.addSubview(pageController!.view)
        pageController!.didMoveToParentViewController(self)
    }
    
    func setUpCollectionViewLayOut()
    {
        let layout = UICollectionViewFlowLayout()
        
        let itemWidth:CGFloat = 200
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 50)
        layout.minimumInteritemSpacing = 1000.0
        layout.minimumLineSpacing = 2.0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        self.relatedItemsCollectionView.collectionViewLayout = layout
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - WebView
    func webViewDidFinishLoad(webView: UIWebView)
    {
        
    }
    
    // MARK: - PageViewController
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! ContentViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound)
        {
            return nil
        }
        
        index = index! - 1
        return viewControllerAtIndex(index!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! ContentViewController).pageIndex
        
        if index == NSNotFound
        {
            return nil
        }
        
        index = index! + 1
        if index == self.pictureModels.count
        {
            return nil
        }
        return viewControllerAtIndex(index!)
    }
    
    func viewControllerAtIndex(index: Int) -> ContentViewController?
    {
         if (self.pictureModels.count == 0) || (index >= self.pictureModels.count)
         {
            return nil
         }
       
         let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
         let dataViewController = storyBoard.instantiateViewControllerWithIdentifier("contentView") as! ContentViewController
       
         dataViewController.imageURLString = (self.pictureModels[index] as! PictureModel).FullSizeImageUrl
         dataViewController.pageIndex = index
         dataViewController.presentingVC = self
        
         return dataViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pictureModels.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    // MARK: CollectionView
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.relatedProducts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) ->
        UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(categoryCellIdentifier, forIndexPath: indexPath) as! CategoryCollectionViewCell
        
        // Configure the cell
        cell.layer.borderWidth = 2.0
        cell.layer.cornerRadius = 8.0
        cell.layer.borderColor = UIColor.grayColor().CGColor
        
        cell.nameLabel.text = (self.relatedProducts.objectAtIndex(indexPath.row) as! AssociatedProducts).Name
        cell.shortDescLabel.text = (self.relatedProducts.objectAtIndex(indexPath.row) as! AssociatedProducts).ShortDescription
        
        let font:UIFont? = UIFont(name: "Avenir Next Condensed", size: 17.0)
        
        let currentPriceText = (self.relatedProducts.objectAtIndex(indexPath.row) as! AssociatedProducts).Price
        let oldPriceText = (self.relatedProducts.objectAtIndex(indexPath.row) as! AssociatedProducts).OldPrice
        
        var currentPriceAttributedText: NSMutableAttributedString =  NSMutableAttributedString(string: "\(currentPriceText) ")
        currentPriceAttributedText.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, currentPriceAttributedText.length))
        currentPriceAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, currentPriceAttributedText.length))
        
        
        var oldPriceAttributedText: NSMutableAttributedString =  NSMutableAttributedString(string: oldPriceText)
        oldPriceAttributedText.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, oldPriceAttributedText.length))
        oldPriceAttributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, oldPriceAttributedText.length))
        oldPriceAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, oldPriceAttributedText.length))
        
        currentPriceAttributedText.appendAttributedString(oldPriceAttributedText)
        
        cell.priceLabel.attributedText = currentPriceAttributedText
        
        let imageURL = (self.relatedProducts.objectAtIndex(indexPath.row) as! AssociatedProducts).ImageUrl
        
        cell.catImageView.image = nil
        cell.request?.cancel()
        
        cell.request = Alamofire.request(.GET, imageURL).responseImage() {
            (request, _, image, error) in
            
            if error == nil && image != nil
            {
                cell.catImageView.image = image
            }
            
            cell.soldOutImageView.hidden = true;
        }
        
        return cell
    }
    
    @IBAction func addToCart(sender: AnyObject)
    {
        
    }
    
    @IBAction func callToOrder(sender: AnyObject)
    {
        
    }
}
