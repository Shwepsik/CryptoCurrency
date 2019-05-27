//
//  GetCoinInfoResponse.swift
//  CryptoCurrency
//
//  Created by Valerii on 26.04.2019.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation

class GetCoinInfoResponse {
    
    var coinInfo: [CoinInfoModel]
    var coinName: [String]
    var symbolName: String
    
    init?(json: JSON) {
        guard let data = json["data"] as? [JSON] else {
            return nil
        }
                
        let coinInfo = data.map{ CoinInfoModel(json: $0) }.compactMap{ $0 }
        self.coinInfo = coinInfo
        self.coinName = coinInfo.map({$0.name})
        self.symbolName = coinInfo.map({$0.symbol}).joined(separator: ",")
    }
}
