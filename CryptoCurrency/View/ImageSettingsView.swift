//
//  ImageSettingsView.swift
//  CryptoCurrency
//
//  Created by Valerii on 03.05.2019.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit
import Kingfisher

class ImageSettingsView: UITableViewController {

    
    @IBOutlet weak var rankLable: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var fontSwitch: UISwitch!
    @IBOutlet weak var fontLable: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontSwitch.setOn(UserDefaults.standard.bool(forKey: "keyFontSwitch"), animated: true)
        view.backgroundColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "viewColorKey"))
    }
    
    
    @IBAction func fontChange(_ sender: UISwitch) {
        UserDefaults.standard.set(fontSwitch.isOn, forKey: "keyFontSwitch")
        if fontSwitch.isOn {
            UserDefaults.standard.set("Helvetica-Bold", forKey: "fontName")
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        } else {
            UserDefaults.standard.set("Helvetica", forKey: "fontName")
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "tableViewColorKey"))
        cell.textLabel?.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
        
        switch indexPath.section {
        case UserDefaults.standard.integer(forKey: "selectedSectionImage"):
            switch indexPath.row {
            case UserDefaults.standard.integer(forKey: "selectedRowImage"):
                cell.accessoryType = .checkmark
            default:
                break
            }
        case 0:
            let fontName = UserDefaults.standard.string(forKey: "fontName")
            let fontSize = UserDefaults.standard.float(forKey: "fontSize")
            nameLable.text = UserDefaults.standard.string(forKey: "nameKey")
            nameLable.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
            nameLable.font = UIFont(name: fontName!, size: CGFloat(fontSize))
            priceLable.text = UserDefaults.standard.string(forKey: "priceKey")
            priceLable.font = UIFont(name: fontName!, size: CGFloat(fontSize))
            priceLable.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
            rankLable.font = UIFont(name: fontName!, size: CGFloat(fontSize))
            rankLable.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
            fontLable.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
            coinImageView.kf.setImage(with: URL(string: UserDefaults.standard.string(forKey: "imageLableKey")!))
        default:
            break
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
       
        switch indexPath {
        case [1,0]:
            UserDefaults.standard.set(cell?.textLabel?.text, forKey: "imageKey")
            UserDefaults.standard.set(0xffffff, forKey: "tableViewColorKey")
            UserDefaults.standard.set(0xEFEFF4, forKey: "viewColorKey")
            view.backgroundColor = UIColor(rgb: 0xEFEFF4)
            UserDefaults.standard.set(0, forKey: "selectedRowImage")
            UserDefaults.standard.set(1, forKey: "selectedSectionImage")
            UserDefaults.standard.set(0x000000, forKey: "textColorKey")
            UserDefaults.standard.set(0xEFEFF4, forKey: "sectionColorKey")
            resetChecks()
            cell?.accessoryType = .checkmark
            tableView.reloadData()
        case [1,1]:
            UserDefaults.standard.set(0x181818, forKey: "viewColorKey")
            view.backgroundColor = UIColor(rgb: 0x181818)
            UserDefaults.standard.set(cell?.textLabel?.text, forKey: "imageKey")
            UserDefaults.standard.set(0x484848, forKey: "tableViewColorKey")
            UserDefaults.standard.set(1, forKey: "selectedRowImage")
            UserDefaults.standard.set(1, forKey: "selectedSectionImage")
            UserDefaults.standard.set(0xffffff, forKey: "textColorKey")
            UserDefaults.standard.set(0xA9A9A9, forKey: "sectionColorKey")
            resetChecks()
            cell?.accessoryType = .checkmark
            tableView.reloadData()
        default:
            break
        }
    }
    
    func resetChecks() {
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                if let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) {
                    cell.accessoryType = .none
                }
            }
        }
    }
}
