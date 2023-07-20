//
//  menuCellTableViewCell.swift
//  myDrinkApp
//
//  Created by Jeremy on 2023/6/2.
//

import UIKit

class MenuCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var priceLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
