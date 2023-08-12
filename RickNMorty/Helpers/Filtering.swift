//
//  Filtering.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 11.08.2023.
//

import UIKit

class Filtering {
    static func filterAndReloadData(with query: String, reloadDataFunction: () -> Void, tableView: UITableView) {
        if query.isEmpty || query.count < 3 {
            reloadDataFunction()
        } else {
            reloadDataFunction()
        }
        tableView.reloadData()
    }
}
