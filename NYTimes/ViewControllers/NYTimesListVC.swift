//
//  NYTimesListVC.swift
//  NYTimes
//
//  Created by Umar Khan on 19/11/18.
//  Copyright © 2018 Mohammad. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class NYTimesListVC: UIViewController {
    
    // MARK: Properties and Variables...
    enum reuseidentifierClassName : String {
        case NYTimecTableCellClass = "NYTimecTableCell"
        case NYTimecTableCellClassIdentifier = "nYTimecTableCell"
    }
    
    var nytimesDict = [[String:String]]()

    // MARK: IBOutlet...
    @IBOutlet weak var nyTimesTableView: UITableView!
    
    // MARK: ViewLifeCycle...
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUpSubViews()
    }
    
    // MARK: ViewLifeCycle...
    private func initialSetUpSubViews(){
        nyTimesMostPopularListWebservices()
        self.nyTimesTableView.register(UINib(nibName: reuseidentifierClassName.NYTimecTableCellClass.rawValue, bundle: nil), forCellReuseIdentifier: reuseidentifierClassName.NYTimecTableCellClassIdentifier.rawValue)
        self.nyTimesTableView.rowHeight = 140
    }
}

// MARK: Webservices
extension NYTimesListVC{
    
    func nyTimesMostPopularListWebservices(){
        WebServices.viewAllNewyorkTimesmostPopularList(param: [:], viewAllNewyorkTimesCompleted: { (jsonData) in
            
            var nyTimesTempDict = [String:String]()
            for item in jsonData["results"].arrayValue{
                
                if item["title"].stringValue != "" {
                    nyTimesTempDict["headerTitle"] = item["title"].stringValue
                }
                else {
                    nyTimesTempDict["headerTitle"] = " "
                }
                if item["byline"].stringValue != "" {
                    nyTimesTempDict["author"] = item["byline"].stringValue
                }
                else {
                    nyTimesTempDict["author"] = " "
                }
                
                if item["abstract"].stringValue != "" {
                    nyTimesTempDict["description"] = item["abstract"].stringValue
                }
                else {
                    nyTimesTempDict["description"] = " "
                }
                
                if item["published_date"].stringValue != "" {
                    nyTimesTempDict["published_date"] = item["published_date"].stringValue
                }
                else {
                    nyTimesTempDict["published_date"] = " "
                }
                
                for imageItems in item["media"].arrayValue{
                    
                    for imageUrlItems in imageItems["media-metadata"].arrayValue{
                        if imageUrlItems["format"].stringValue == "Standard Thumbnail"{
                            
                            if let imgUrl = imageUrlItems["url"].string{
                                nyTimesTempDict["imageUrl"] = imgUrl
                            }else {
                                nyTimesTempDict["imageUrl"] = ""
                            }
                        }
                    }
                }
                
                self.nytimesDict.append(nyTimesTempDict)
            }
            self.nyTimesTableView.reloadData()
            
        }) { (err) in
            print(err.localizedDescription)
        }
    }
}

// MARK: UITableView Delegate and DataSource methods...
extension NYTimesListVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nytimesDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifierClassName.NYTimecTableCellClassIdentifier.rawValue, for: indexPath) as? NYTimecTableCell else {return UITableViewCell()}

        cell.headerTitleLabel.text = nytimesDict[indexPath.row]["headerTitle"]
        cell.subTitleLabel.text = nytimesDict[indexPath.row]["author"]
        cell.publishedDateLabel.text = nytimesDict[indexPath.row]["published_date"]
        cell.nyTimesImage.sd_setImage(with: URL(string: nytimesDict[indexPath.row]["imageUrl"] ?? ""), placeholderImage: UIImage(named: "placeholder"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewVC = self.storyboard?.instantiateViewController(withIdentifier: "NYTimesDetailsVC") as! NYTimesDetailsVC
          detailsViewVC.detailsDict["headerTitle"] = nytimesDict[indexPath.row]["headerTitle"]
          detailsViewVC.detailsDict["author"] = nytimesDict[indexPath.row]["author"]
          detailsViewVC.detailsDict["imageUrl"] = nytimesDict[indexPath.row]["imageUrl"]
          detailsViewVC.detailsDict["published_date"] = nytimesDict[indexPath.row]["published_date"]
          detailsViewVC.detailsDict["description"] = nytimesDict[indexPath.row]["description"]
        self.navigationController?.pushViewController(detailsViewVC, animated: true)
        
    }
    
    
}
