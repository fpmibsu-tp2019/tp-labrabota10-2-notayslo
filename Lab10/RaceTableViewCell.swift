//
//  RaceTableViewCell.swift
//  Lab10
//
//  Created by Anton Sipaylo on 6/7/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import UIKit

class RaceTableViewCell: UITableViewCell {
    @IBOutlet weak var raceNameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setRaceName(_ name: String) {
        raceNameLabel.text = name
    }
    
    func setCompanyName(_ name: String) {
        companyNameLabel.text = name
    }
    
    func setCostValue(_ cost: Double) {
        costLabel.text = String(cost)
    }
}
