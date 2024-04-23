//
//  ClickableCollectionViewCell.swift
//  Path Finder
//
//  Created by Vishwa Fernando on 2024-04-20.
//

import UIKit

class ClickableCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ClickableCollectionViewCell.self)

    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
