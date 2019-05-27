//
//  Checksss.swift
//  CryptoCurrency
//
//  Created by Valerii on 30.04.2019.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation


class GetImageResponse {
    
    var image: [ImageModel]
    
    init?(json: JSON) {
        guard let data = json["data"] as? JSON else {
            return nil
        }
        
        let image = data.map { (arg: (key: String, value: AnyObject)) -> ImageModel in
            return ImageModel(json: arg)!
        }
        self.image = image
    }
}
