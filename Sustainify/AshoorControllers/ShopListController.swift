import UIKit

class ShopListController: UITableViewController {

    var shops: [Shop] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath)
        let shop = shops[indexPath.row]
        cell.textLabel?.text = shop.name
        cell.detailTextLabel?.text = shop.location
        // Set the accessory type to disclosure indicator
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Delete"
    }

    @IBAction func addShopButtonTapped(_ sender: UIBarButtonItem) {
        // Code to present AddShopController
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shops.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func unwindToShopList(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddShopController, let newShop = sourceVC.newShop {
            shops.append(newShop)
            tableView.reloadData()
            print("Shop Added: The shop has been added successfully.")
        } else if let sourceVC = segue.source as? EditShopController, let updatedShop = sourceVC.updatedShop, let index = sourceVC.shopIndex {
            shops[index] = updatedShop
            tableView.reloadData()
            print("Shop Updated: The shop details have been updated successfully.")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditShop", let destinationVC = segue.destination as? EditShopController, let indexPath = tableView.indexPathForSelectedRow {
            let shop = shops[indexPath.row]
            destinationVC.shopToEdit = shop
            destinationVC.shopIndex = indexPath.row
        }
    }
}
