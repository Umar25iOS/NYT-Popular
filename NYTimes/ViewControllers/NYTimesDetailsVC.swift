//
//  NYTimesDetailsVC.swift
//  NYTimes
//
//  Created by Umar Khan on 19/11/18.
//  Copyright © 2018 Mohammad. All rights reserved.
//

import UIKit
import SDWebImage

class NYTimesDetailsVC: UIViewController {

    // MARK: Variables...
    var detailsDict = [String:String]()
    
    // MARK: IBOutlet...
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: View LifeCycle...
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetUp()
    }
    
    // MARK: View Initial SetUp...
    private func initialSetUp(){
        Globals.circularImage(image: authorImage)
        titleLabel.text = detailsDict["headerTitle"]
        authorImage.sd_setImage(with: URL(string: detailsDict["imageUrl"] ?? ""), placeholderImage: UIImage(named: "placeholder"))
        authorLabel.text = detailsDict["author"]
        descriptionLabel.text = detailsDict["description"]
        dateLabel.text = detailsDict["published_date"]
    }
    
    // MARK: IBAction...
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
