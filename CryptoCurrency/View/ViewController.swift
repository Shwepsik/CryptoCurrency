//
//  ViewController.swift
//  CryptoCurrency
//
//  Created by Valerii on 26.04.2019.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit
import Kingfisher


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var myTableVIew: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var coinInfo = [CoinInfoModel]()
    var model = [String]()
    var symbolName = String()
    var coinName = [String]()
    var imageModel = [ImageModel]()
    var filtered = [CoinInfoModel]()
    var arrayForSettings = [CoinInfoModel]()
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        
        ApiController.shared.tryLoadCoinInfo { (model) in
            self.coinInfo = model.coinInfo
            self.coinName = model.coinName
            self.symbolName = model.symbolName

            ApiController.shared.tryLoadCoinImage(param: ["symbol" : self.symbolName], { (model) in
                self.imageModel = model.image
                self.imageModel = self.imageModel.sorted{ self.coinName.index(of: $0.name)! < self.coinName.index(of: $1.name)! }
                let linkArray = self.imageModel.map{($0.logo)}
                self.addLogo(links: linkArray)
                self.myTableVIew.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = self.myTableVIew.cellForRow(at: indexPath) as! CustomCells
                UserDefaults.standard.set(cell.nameLable.text, forKey: "nameKey")
                UserDefaults.standard.set(cell.priceLable.text, forKey: "priceKey")
                UserDefaults.standard.set(linkArray[0], forKey: "imageLableKey")
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "tableViewColorKey"))
        self.myTableVIew.backgroundColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "viewColorKey"))
        self.myTableVIew.reloadData()
    }
    
    func setUpSearchBar() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 255/255, blue: 198/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.searchBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColor(red: 0/255, green: 255/255, blue: 198/255, alpha: 1).cgColor
        self.searchBar.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 198/255, alpha: 1)
        
    }

    
    func addLogo(links: [String]) {
        for i in 0..<self.coinInfo.count {
            self.coinInfo.first(where: { $0.name == self.coinName[i] })?.logo = links[i]
        }
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            isSearching = true
            filterContent(searchText: searchText)
            myTableVIew.reloadData()
        } else {
            isSearching = false
            myTableVIew.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchBar.becomeFirstResponder()
        }
    }
    
    func filterContent(searchText: String) {
        filtered = coinInfo.filter({ (coin: CoinInfoModel) -> Bool in
            let nameMatch = coin.name.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            let symbolMatch = coin.symbol.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            return nameMatch != nil || symbolMatch != nil
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching == false {
            return coinInfo.count
        } else {
            return filtered.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if coinInfo[section].opened == true {
            return coinInfo[section].sections.count + 1
        } else {
          return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
            tableView.deselectRow(at: indexPath, animated: false)
            
        } else if coinInfo[indexPath.section].opened == false {
            coinInfo[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            myTableVIew.reloadSections(sections, with: .none)
            
        } else if coinInfo[indexPath.section].opened == true  {
            coinInfo[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            myTableVIew.reloadSections(sections, with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let fontSize = UserDefaults.standard.float(forKey: "fontSize")
        let fontName = UserDefaults.standard.string(forKey: "fontName")
        
        if indexPath.row == 0 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCells
        cell.backgroundColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "tableViewColorKey"))
        let coinsInfo = (isSearching) ? filtered[indexPath.section] : coinInfo[indexPath.section]
        
            
        cell.nameLable.text = coinsInfo.name
        cell.nameLable.font = UIFont(name: fontName!, size: CGFloat(fontSize))
        cell.nameLable.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
        cell.rankLable.text = ("#\(coinsInfo.rank)")
        cell.rankLable.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
        cell.rankLable.font = UIFont(name: fontName!, size: CGFloat(fontSize))
        cell.priceLable.text = coinsInfo.price
        cell.priceLable.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
        cell.priceLable.font = UIFont(name: fontName!, size: CGFloat(fontSize))
            if coinsInfo.logo != nil {
                cell.coinImage.kf.setImage(with: URL(string:coinsInfo.logo!))
            }
        
        return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sections") as! SectionsCell
            cell.backgroundColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "sectionColorKey"))
            let coinsInfo = (isSearching) ? filtered[indexPath.section] : coinInfo[indexPath.section]
            
            cell.leftLable.text = coinsInfo.sections[indexPath.row - 1].leftLable
            cell.leftLable.font = UIFont(name: fontName!, size: CGFloat(fontSize))
            cell.rightLable.text = coinsInfo.sections[indexPath.row - 1].rightLable
            cell.rightLable.textColor = coinsInfo.sections[indexPath.row - 1].color
            cell.rightLable.font = UIFont(name: fontName!, size: CGFloat(fontSize))
            cell.topLable.text = coinsInfo.sections[indexPath.row - 1].topLable
            cell.topLable.font = UIFont(name: fontName!, size: CGFloat(fontSize))
            cell.botomLable.text = coinsInfo.sections[indexPath.row - 1].bottomLable
            cell.botomLable.font = UIFont(name: fontName!, size: CGFloat(fontSize))
            
            return cell
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
