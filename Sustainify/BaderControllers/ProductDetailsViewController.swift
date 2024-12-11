//
//  ProductDetailsViewController.swift
//  Sustainify
//
//  Created by Guest User on 11/12/2024.
//

import UIKit

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.reduce(0) { $0 + ($1.isExpanded ? 2 : 1) }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var currentIndex = 0
        for item in data {
            if currentIndex == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ecoScoreCell", for: indexPath)
                cell.textLabel?.text = item.title
                return cell
            }
            currentIndex += 1
            
            if item.isExpanded && currentIndex == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ecoScoreDetailsCell", for: indexPath)
                cell.textLabel?.text = item.details
                return cell
            }
            if item.isExpanded {
                currentIndex += 1
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
