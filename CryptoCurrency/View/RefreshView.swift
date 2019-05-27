//
//  RefreshView.swift
//  CryptoCurrency
//
//  Created by Valerii on 02.05.2019.
//  Copyright © 2019 Valerii. All rights reserved.
//

import UIKit

class RefreshView: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "viewColorKey"))
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "textColorKey"))
        cell.backgroundColor = UIColor(rgb: UserDefaults.standard.integer(forKey: "tableViewColorKey"))
        switch indexPath.row {
        case UserDefaults.standard.integer(forKey: "selectedRowRefresh"):
            cell.accessoryType = .checkmark
        default:
            break
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        
        switch indexPath.row {
        case 0:
            UserDefaults.standard.set(cell?.textLabel?.text, forKey: "refreshKey")
            UserDefaults.standard.set(0, forKey: "selectedRowRefresh")
        case 1:
            UserDefaults.standard.set(cell?.textLabel?.text, forKey: "refreshKey")
            UserDefaults.standard.set(1, forKey: "selectedRowRefresh")
        default:
            break
        }
        resetChecks()
        cell?.accessoryType = .checkmark
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
