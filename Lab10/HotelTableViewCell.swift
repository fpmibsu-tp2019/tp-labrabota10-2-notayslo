//
//  HotelTableViewCell.swift
//  Lab10
//
//  Created by Anton Sipaylo on 6/1/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import UIKit

class HotelTableViewCell: UITableViewCell {
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelDescriptionLabel: UILabel!
    @IBOutlet weak var hotelCityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
