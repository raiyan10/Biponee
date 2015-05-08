//
//  ContentViewController.swift
//  Biponee
//
//  Created by Masudur Rahman on 5/6/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit
import Alamofire

class ContentViewController: UIViewController {

    var imageURLString: String?
    var request: Alamofire.Request?
    var pageIndex: Int?
    var presentingVC: ProductDetailViewController?
    
    let tapRec = UITapGestureRecognizer()
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tapRec.numberOfTapsRequired = 1
        tapRec.addTarget(self, action: "imageViewTapped")
        self.view.addGestureRecognizer(tapRec)
        
        let imageURL = imageURLString
        
        self.imageView.image = nil
        self.request?.cancel()
        
        self.request = Alamofire.request(.GET, imageURL!).responseImage() {
            (request, _, image, error) in
            
            if error == nil && image != nil
            {
                self.imageView.image = image
            }
        }
    }
    
    func imageViewTapped()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let toBePresentedVC = storyBoard.instantiateViewControllerWithIdentifier("fullImageViewCon") as! FullImageViewController
        toBePresentedVC.productImage = self.imageView.image
        
        presentingVC!.presentViewController(toBePresentedVC, animated: true, completion: nil)
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

}
