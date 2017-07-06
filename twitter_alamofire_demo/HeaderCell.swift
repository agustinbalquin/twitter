//
//  HeaderCell.swift
//  twitter_alamofire_demo
//
//  Created by Agustin Balquin on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    @IBOutlet weak var tweets: UIButton!
    @IBOutlet weak var tnr: UIButton!
    @IBOutlet weak var media: UIButton!
    @IBOutlet weak var likes: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
