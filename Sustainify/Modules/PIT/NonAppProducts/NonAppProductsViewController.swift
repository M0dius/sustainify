//
//  NonAppProductsViewController.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 29/12/24.
//

import UIKit

class NonAppProductsViewController: UIViewController {

    // MARK: - Properties
    private var nonAppItemArray: [NonAppItem] = []

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        configureView()
    }

    private func configureView() {
        self.navigationItem.title = "Non-App Products"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Delete",
            style: .plain,
            target: self,
            action: #selector(deleteAllItems)
        )
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ], for: .normal)
    }

    // MARK: - IBActions
    @IBAction func addProductAction(sender: UIButton) {
        let item = NonAppItem(name: "", company: "", categories: [], ecoTags: [])
        navigateToNonAppForm(with: item) { [weak self] updatedItem in
            guard let self = self else { return }
            if let index = self.nonAppItemArray.firstIndex(where: { $0.id == updatedItem.id }) {
                self.nonAppItemArray[index] = updatedItem
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            } else {
                self.nonAppItemArray.append(updatedItem)
                self.tableView.insertRows(at: [IndexPath(row: self.nonAppItemArray.count - 1, section: 0)], with: .automatic)
            }
        }
    }

    // MARK: - Delete All Items
    @objc func deleteAllItems() {
        self.showAlert(
            ofType: .deleteAll,
            actions: [
                (.cancel, nil),
                (.destructive, { [weak self] in
                    guard let self = self else { return }
                    self.nonAppItemArray.removeAll()
                    self.tableView.reloadData()
                })
            ]
        )
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension NonAppProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonAppItemArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        cell.textLabel?.text = nonAppItemArray[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = nonAppItemArray[indexPath.row]
        navigateToNonAppForm(with: item, title: "Edit Product") { [weak self] updatedItem in
            guard let self = self else { return }
            self.nonAppItemArray[indexPath.row] = updatedItem
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            nonAppItemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Helper Method
extension NonAppProductsViewController {
    private func navigateToNonAppForm(with item: NonAppItem, title: String =  "Add Product", completion: @escaping (NonAppItem) -> Void) {
        let intent = AddProductNavigationIntent()
        NavigationManager.show(intent, on: self.navigationController, animation: .push) { (vc: NonAppFormController) in
            vc.item = item
            vc.navigationTitle = title
            vc.onItemUpdated = completion
        }
    }
}
