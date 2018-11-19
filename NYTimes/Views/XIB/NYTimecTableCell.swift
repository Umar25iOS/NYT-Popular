//
//  NYTimecTableCell.swift
//  NYTimes
//
//  Created by Umar Khan on 19/11/18.
//  Copyright © 2018 Mohammad. All rights reserved.
//

import UIKit

class NYTimecTableCell: UITableViewCell {

    // MARK: IBOutlets....
    @IBOutlet weak var nyTimesImage: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var rightArrowButton: UIButton!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Globals.circularImage(image: nyTimesImage)
        selectionStyle = .none
    }
    
}
