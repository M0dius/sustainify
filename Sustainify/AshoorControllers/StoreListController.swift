import UIKit

class StoreListController: UITableViewController {

    var stores: [Store] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath)
        let store = stores[indexPath.row]
        cell.textLabel?.text = store.name
        cell.detailTextLabel?.text = store.location
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Delete"
    }

    @IBAction func addStoreButtonTapped(_ sender: UIBarButtonItem) {
        // Code to present AddStoreController
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stores.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func unwindToStoreList(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddStoreController, let newStore = sourceVC.newStore {
            stores.append(newStore)
            tableView.reloadData()
            print("Store Added: The store has been added successfully.")
        } else if let sourceVC = segue.source as? EditStoreController, let updatedStore = sourceVC.updatedStore, let index = sourceVC.storeIndex {
            stores[index] = updatedStore
            tableView.reloadData()
            print("Store Updated: The store details have been updated successfully.")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditStore", let destinationVC = segue.destination as? EditStoreController, let indexPath = tableView.indexPathForSelectedRow {
            let store = stores[indexPath.row]
            destinationVC.storeToEdit = store
            destinationVC.storeIndex = indexPath.row
        }
    }
}
