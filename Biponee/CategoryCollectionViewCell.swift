//
//  CategoryCollectionViewCell.swift
//  Biponee
//
//  Created by Masudur Rahman on 5/4/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

import UIKit
import Alamofire

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var request: Alamofire.Request?
    
    @IBOutlet var catImageView: UIImageView!
    @IBOutlet var soldOutImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var shortDescLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
}
