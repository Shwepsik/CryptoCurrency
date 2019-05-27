//
//  SettingsView.swift
//  CryptoCurrency
//
//  Created by Valerii on 01.05.2019.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit

class SettingsView: UITableViewController {
    
    
    @IBOutlet weak var appNameLable: UILabel!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var soundLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        soundSwitch.setOn(UserDefaults.standard.bool(forKey: "keySoundSwitch"), animated: true)
        view.backgroundColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "viewColorKey"))
        appNameLable.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "tableViewColorKey"))
        cell.textLabel?.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
        soundLable.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
        switch indexPath {
        case [1,0]:
            cell.detailTextLabel?.text = UserDefaults.standard.value(forKey: "imageKey") as? String
        case [1,1]:
            cell.detailTextLabel?.text = UserDefaults.standard.value(forKey: "refreshKey") as? String
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func keySound(_ sender: UISwitch) {
        UserDefaults.standard.set(soundSwitch.isOn, forKey: "keySoundSwitch")
    }
}
