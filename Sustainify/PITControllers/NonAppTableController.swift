//
//  AddNonAppController.swift
//  Sustainify
//
//  Created by User on 24/06/1446 AH.
//

import UIKit

class NonAppTableController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var nonAppItemArray: [NonAppItem] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
//    func createFloatingButton() {
//        let floatingButton = UIButton()
////        floatingButton.setTitle("Add", for: .normal)
//        floatingButton.setImage(.init(systemName: "plus"), for: .normal)
//        floatingButton.tintColor = .white
//        floatingButton.backgroundColor = .appGreen
//        floatingButton.layer.cornerRadius = 6
//        floatingButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
//        self.view.addSubview(floatingButton)
//        
//        floatingButton.translatesAutoresizingMaskIntoConstraints = false
//        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        floatingButton.bottomAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
//        floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
////        floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//    }
    
    @objc func addButtonPressed(_ sender: Any) {
        let indexPath = [IndexPath(row: nonAppItemArray.count, section: 0)]
        let item = NonAppItem(name: "", company: "", categories: [], ecoTags: [])
        
        // Create VC
        let storyboard = UIStoryboard(name: "MoPIT", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NonAppForm") as! NonAppFormController
        
        // Set vc with details
        vc.item = item
//        vc.onItemUpdated = { [weak self] in
//            if self?.nonAppItemArray.contains(where: { $0.id == item.id }) == true {
//                self?.tableView.reloadRows(at: indexPath, with: .automatic)
//            } else {
//                self?.nonAppItemArray.append(item)
//                self?.tableView.insertRows(at: indexPath, with: .automatic)
//            }
//        }
        
        // Present vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func toggleEditMode(_ sender: Any) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditMode)), animated: true)
        } else {
            tableView.setEditing(true, animated: true)
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toggleEditMode)), animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set TableView delegates
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Set NavigationItem Details
        self.navigationItem.title = "Non-App Products"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditMode))
        
        // Add Create Button
        //createFloatingButton()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get item
        let item = nonAppItemArray[indexPath.row]
        
        // Create VC
        let storyboard = UIStoryboard(name: "MoPIT", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NonAppForm") as! NonAppFormController
        
        // Set vc with details
        vc.item = item
//        vc.onItemUpdated = { [weak self] in
//            self?.tableView.reloadRows(at: [indexPath], with: .none)
//        }
        
        // Present vc
        self.navigationController?.pushViewController(vc, animated: true)
        
        // Deselect Row so it doesn't seem broken
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nonAppItemArray.count // Number of items in array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        cell.textLabel?.text = nonAppItemArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Only Supports delete
        if editingStyle == .delete {
            nonAppItemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
