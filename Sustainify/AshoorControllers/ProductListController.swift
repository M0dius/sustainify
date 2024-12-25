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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)  // Custom font size and weight
        cell.detailTextLabel?.text = product.company
        // Set the accessory type to disclosure indicator
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func unwindToProductList(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddProductController, let newProduct = sourceVC.newProduct {
            products.append(newProduct)
            tableView.reloadData()
            print("Product Added: The product has been added successfully.")
        } else if let sourceVC = segue.source as? EditProductController, let updatedProduct = sourceVC.updatedProduct, let index = sourceVC.productIndex {
            products[index] = updatedProduct
            tableView.reloadData()
            print("Product Updated: The product details have been updated successfully.")
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
