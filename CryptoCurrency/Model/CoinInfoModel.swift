//
//  CoinInfoModel.swift
//  CryptoCurrency
//
//  Created by Valerii on 26.04.2019.
//  Copyright © 2019 Valerii. All rights reserved.
//

import Foundation
import UIKit

struct Sections {
    
    var leftLable: String
    var rightLable: String
    var topLable: String
    var bottomLable: String
    var color: UIColor
}

class CoinInfoModel: NSObject {
    
    var logo: String?
    var name: String
    var price: String
    var opened: Bool
    var rank: String
    var symbol: String
    var sections: [Sections]
    
    
    init?(json: JSON) {
        guard let name = json["name"] as? String,
        let symbol = json["symbol"] as? String,
        let rank = json["cmc_rank"] as? Int,
        let quote = json["quote"] as? [String: AnyObject],
        let usd = quote["USD"] as? [String: AnyObject],
        let price = usd["price"] as? Double,
        let marketCap = usd["market_cap"] as? Double,
        let volume24h = usd["volume_24h"] as? Double,
        let lastUpdate = usd["last_updated"] as? String,
        let change24h = usd["percent_change_24h"] as? Double else {
            return nil
        }
        
        self.symbol = symbol
        self.name = name
        self.opened = false
        self.rank = String(rank)
        if price < 1 {
            self.price = ("\(String(price.rounded(digits: 6)))$")
        } else {
            self.price = ("\(String(price.rounded(digits: 2)))$")
        }
        var color = UIColor()
        if change24h <= 0 {
            color = UIColor.red
        } else {
            color = UIColor.green
        }
        //UserDefaults.standard.set(lastUpdate, forKey: "lastUpdateKey")
        let change = ("\(String(change24h.rounded(digits: 2)))%")
        let cap = ("\(String(Int(marketCap).formattedWithSeparator))$")
        let volume = ("\(String(Int(volume24h).formattedWithSeparator))$")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+3")
        let dateFromString = dateFormatter.date(from: lastUpdate)
        dateFormatter.dateFormat = "HH:mm"
        let newDate = dateFormatter.string(from: dateFromString!)
        
        self.sections = [Sections(leftLable: "Change (24h)", rightLable: change, topLable: "", bottomLable: "", color: color),
                         Sections(leftLable: "Volume (24h)", rightLable: volume, topLable: "", bottomLable: "", color: UIColor.darkText),
                         Sections(leftLable: "Market Cap", rightLable: cap, topLable: "", bottomLable: "", color: UIColor.darkText),
                         Sections(leftLable: "", rightLable: "", topLable: "Last Update", bottomLable: newDate, color: UIColor.darkText)]
    }
}


extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
