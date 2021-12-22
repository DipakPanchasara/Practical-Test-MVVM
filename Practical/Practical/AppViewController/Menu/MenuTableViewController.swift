//
//  MenuTableViewController.swift
//  Practical
//
//  Created by Dipak Panchasara on 21/06/21.
//

import UIKit

class MenuTableViewController: UITableViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tabBarVC = self.panel?.center as? AppTabViewController {
            self.panel?.closeLeft()
            tabBarVC.selectedIndex = indexPath.row
        }
    }
}
