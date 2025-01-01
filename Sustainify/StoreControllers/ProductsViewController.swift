//
//  ProductsViewController.swift
//

import UIKit

class ProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var store: Store?
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the navigation item title
        self.navigationItem.title = store?.name
        
        // Set up the table view
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Register the prototype cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "productCell")
        
        // Set up constraints for the table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // Implement UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Use allStoreItems instead of items
        return store?.allStoreItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        // Use allStoreItems instead of items
        if let store = store {
            let product = store.allStoreItems[indexPath.row]
            cell.textLabel?.text = product.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedProduct = store?.allStoreItems[indexPath.row] {
            print("Selected Product: \(selectedProduct.name)")
            // Implement navigation or action here for the selected product
        }
    }
}
