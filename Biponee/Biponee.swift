//
//  Biponee.swift
//  Biponee
//
//  Created by Masudur Rahman on 4/30/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit
import Alamofire

struct Biponee
{
    static var rootCategories : AnyObject?
    
    enum Router: URLRequestConvertible
    {
        static let baseURLString = "http://192.168.1.246:9090"
        
        case Categories
        
        var URLRequest: NSURLRequest
        {
            let (path: String, parameters: [String: AnyObject]) =
            {
                switch self
                {
                    case .Categories :
                        let params = Dictionary<String, AnyObject>()
                        return ("/api/categories", params)
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


