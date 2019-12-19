//
//  CustomCollectionViewCell.swift
//  Armani
//
//  Created by Michael Martinez on 18/12/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var cellLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure() {
        
    }
}
