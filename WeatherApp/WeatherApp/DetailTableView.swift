//
//  DetailTableView.swift
//  WeatherApp
//
//  Created by Yusuf Özgül on 30.03.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

class DetailTableView: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxDegree: UILabel!
    @IBOutlet weak var minDegree: UILabel!
    @IBOutlet weak var dayIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
