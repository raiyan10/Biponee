//
//  Biponee.swift
//  Biponee
//
//  Created by Masudur Rahman on 4/30/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit
import Alamofire

extension Alamofire.Request {
    class func imageResponseSerializer() -> Serializer {
        return { request, response, data in
            if data == nil {
                return (nil, nil)
            }
            
            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
            
            return (image, nil)
        }
    }
    
    func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self {
        return response(serializer: Request.imageResponseSerializer(), completionHandler: { (request, response, image, error) in
            completionHandler(request, response, image as? UIImage, error)
        })
    }
}

struct Biponee
{
    static var rootCategories : AnyObject?
    
    enum Router: URLRequestConvertible
    {
        static let baseURLString = "http://192.168.1.246:9090"
        
        case Categories
        case CategoryDetail(Int)
        case ProductDetail(Int)
        
        var URLRequest: NSURLRequest
        {
            let (path: String, parameters: [String: AnyObject]) =
            {
                switch self
                {
                    case .Categories :
                        let params = Dictionary<String, AnyObject>()
                        return ("/api/categories", params)
                    case .CategoryDetail(let categoryId):
                        let params = Dictionary<String, AnyObject>()
                        return ("/api/categories/\(categoryId)", params)
                    case .ProductDetail(let productId):
                        let params = Dictionary<String, AnyObject>()
                        return ("/api/products/\(productId)", params)
                }
            }()
            
            let URL = NSURL(string: Router.baseURLString)
            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
}

class Category : NSObject
{
    let Id: Int
    let Name: String
    let ParentCategoryId: Int
    
    init(id: Int, name: String, parentId: Int)
    {
        self.Id = id
        self.Name = name
        self.ParentCategoryId = parentId
    }
}

class CategoryDetails : NSObject
{
    let Id: Int
    let Name: String
    let ShortDescription: String
    let OldPrice: String
    let Price: String
    let AvailableForPreOrder: Bool
    let ImageUrl: String
    
    init(JSON: AnyObject)
    {
        self.Id = JSON.valueForKeyPath("Id") as! Int
        self.Name = JSON.valueForKeyPath("Name") as! String
        self.ShortDescription = JSON.valueForKeyPath("ShortDescription") as! String
        
        if let prevPrice = JSON.valueForKeyPath("ProductPrice.OldPrice") as? String
        {
            self.OldPrice = prevPrice
        }
        else
        {
            self.OldPrice = ""
        }
        
        self.Price = JSON.valueForKeyPath("ProductPrice.Price") as! String
        self.AvailableForPreOrder = JSON.valueForKeyPath("ProductPrice.AvailableForPreOrder") as! Bool
        self.ImageUrl = JSON.valueForKeyPath("DefaultPictureModel.ImageUrl") as! String
    }
}

class ProductDetail : NSObject
{
    let Name: String
    let ShortDescription: String
    let FullDescription: String
    let OldPrice: String
    let Price: String
    let manufacturerName: String
    
    init(name: String, shortDesc: String, fullDesc: String, productPrice: AnyObject, productManufacturer: AnyObject)
    {
        self.Name = name
        self.ShortDescription = shortDesc
        self.FullDescription = fullDesc
        self.Price = productPrice.valueForKey("Price") as! String
        
        if let prevPrice = productPrice.valueForKey("OldPrice") as? String
        {
            self.OldPrice = prevPrice
        }
        else
        {
            self.OldPrice = ""
        }
        
        self.manufacturerName = productManufacturer.objectAtIndex(0).valueForKey("Name") as! String
    }
}

class AssociatedProducts : NSObject
{
    let Id: Int
    let Name: String
    let ShortDescription: String
    let OldPrice: String
    let Price: String
    let ImageUrl: String
    
    init(JSON: AnyObject)
    {
        self.Id = JSON.valueForKeyPath("ProductPrice.ProductId") as! Int
        self.Name = JSON.valueForKeyPath("Name") as! String
        self.ShortDescription = JSON.valueForKeyPath("ShortDescription") as! String
        
        if let prevPrice = JSON.valueForKeyPath("ProductPrice.OldPrice") as? String
        {
            self.OldPrice = prevPrice
        }
        else
        {
            self.OldPrice = ""
        }
        
        self.Price = JSON.valueForKeyPath("ProductPrice.Price") as! String
        self.ImageUrl = JSON.valueForKeyPath("DefaultPictureModel.ImageUrl") as! String
    }
}

class PictureModel: NSObject
{
    let ImageUrl: String
    let FullSizeImageUrl: String
    
    init(JSON: AnyObject)
    {
        self.ImageUrl = JSON.valueForKeyPath("ImageUrl") as! String
        self.FullSizeImageUrl = JSON.valueForKeyPath("FullSizeImageUrl") as! String
    }
}

