//
//WebServices
//
//  NYTimes
//
//  Created by Mohammad Umar Khan on 19/11/18.
//  Copyright © 2018 Mohammad. All rights reserved.
//

import Foundation

extension WebServices {
    
    enum EndPoint : String {
        
        case baseURL = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key="
        
        case apiKey = "ef848ca1c21741969bb0459ca8542b65"
        
        var url: String {
            return "\(EndPoint.baseURL.rawValue)\(self.rawValue)"
        }
    }
}

