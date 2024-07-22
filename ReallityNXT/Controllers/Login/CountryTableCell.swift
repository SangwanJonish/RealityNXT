//
//  CountryTableCell.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 15/06/24.
//

import UIKit
import SDWebImage

class CountryTableCell: UITableViewCell {

    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var check: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignData(_ obj: Countries){
        
        countryNameLbl.text = /obj.code + "   " + /obj.countryName
        countryImageView.sd_setImage(with: URL(string: /obj.url), placeholderImage:UIImage(contentsOfFile:"placeholder.png"))
    }

}
