//
//  Check.swift
//  CryptoCurrency
//
//  Created by Valerii on 30.04.2019.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation


class ImageModel {
    
    var name: String
    var logo: String
    
    init?(json: (key:String, value: AnyObject)) {
        guard let name = json.value["name"] as? String,
        let logo = json.value["logo"] as? String else {
            return nil
        }
        self.name = name
        self.logo = logo
    }
}
