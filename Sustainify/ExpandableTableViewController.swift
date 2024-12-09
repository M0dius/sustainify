//
//  ExpandableTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 09/12/2024.
//

import UIKit

class ExpandableTableViewController: UITableViewController {
    
    struct CellData {
        let title: String
        let details: String
        var isExpanded: Bool
    }
    
    var data = [
        CellData(title: "Cell 1", details: "Details for Cell 1", isExpanded: false),
        CellData(title: "Cell 2", details: "Details for Cell 2", isExpanded: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.reduce(0) { $0 + ($1.isExpanded ? 2 : 1) }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var currentIndex = 0
        for item in data {
            if currentIndex == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ecoScoreCell", for: indexPath)
                cell.textLabel?.text = item.title
                return cell
            }
            currentIndex += 1
            
            if item.isExpanded && currentIndex == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ecoScoreDetailCell", for: indexPath)
                cell.textLabel?.text = item.details
                return cell
            }
            if item.isExpanded {
                currentIndex += 1
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currentIndex = 0
        for (index, item) in data.enumerated() {
            if currentIndex == indexPath.row {
                data[index].isExpanded.toggle()
                tableView.reloadData()
                return
            }
            currentIndex += 1
            
            if item.isExpanded {
                currentIndex += 1
            }
        }
    }
}
