//
//  ResultTableViewCell.swift
//  Path Finder
//
//  Created by Vishwa Fernando on 2024-04-23.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ResultTableViewCell.self)
    
    @IBOutlet var lbRank: UILabel!
    @IBOutlet var lbGridSize: UILabel!
    @IBOutlet var lbMoves: UILabel!
    @IBOutlet var lbTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
