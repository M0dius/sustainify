import UIKit

class ProductListController: UITableViewController {

    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = products[indexPath.row]
        cell.textLabel?.text = "\(product.name) - BD\(String(format: "%.2f", product.price))"
        cell.detailTextLabel?.text = "Company: \(product.company) | Stock: \(product.stock)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Delete"
    }

    @IBAction func addProductButtonTapped(_ sender: UIBarButtonItem) {
        // Code to present AddProductController
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addStockAction = UIContextualAction(style: .normal, title: "Add Stock") { (_, _, completionHandler) in
            self.products[indexPath.row].stock += 1
            tableView.reloadRows(at: [indexPath], with: .none)
            completionHandler(true)
        }

        let removeStockAction = UIContextualAction(style: .destructive, title: "Remove Stock") { (_, _, completionHandler) in
            if self.products[indexPath.row].stock > 0 {
                self.products[indexPath.row].stock -= 1
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [addStockAction, removeStockAction])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func unwindToProductList(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddProductController, let newProduct = sourceVC.newProduct {
            products.append(newProduct)
            tableView.reloadData()
        } else if let sourceVC = segue.source as? EditProductController, let updatedProduct = sourceVC.updatedProduct, let index = sourceVC.productIndex {
            products[index] = updatedProduct
            tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditProduct", let destinationVC = segue.destination as? EditProductController, let indexPath = tableView.indexPathForSelectedRow {
            let product = products[indexPath.row]
            destinationVC.productToEdit = product
            destinationVC.productIndex = indexPath.row
        }
    }
}
