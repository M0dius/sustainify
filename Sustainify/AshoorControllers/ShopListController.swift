import UIKit
import FirebaseFirestore

class ShopListController: UITableViewController {
    
    let db = Firestore.firestore()
    var shops: [Shop] = []
    
    func fetchShops() {
        db.collection("Stores").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            
            self.shops = documents.compactMap { doc in
                let data = doc.data()
                return Shop(
                    name: data["name"] as? String ?? "",
                    crNumber: data["crNumber"] as? Int ?? 0,
                    building: data["building"] as? Int ?? 0,
                    road: data["road"] as? Int ?? 0,
                    block: data["block"] as? Int ?? 0,
                    openingTime: data["openingTime"] as? String,
                    closingTime: data["closingTime"] as? String,
                    description: data["description"] as? String, // Fetch description
                    minimumOrderAmount: data["minimumOrder"] as? Double ?? nil,
                    storeCategories: data["storeCategories"] as? [String] ?? [],
                    storeImage: nil,
                    paymentOptions: data["paymentOptions"] as? [String] ?? []
                )
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }



    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchShops()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath)
        let shop = shops[indexPath.row]

        let openingTime = shop.openingTime ?? "N/A"
        let closingTime = shop.closingTime ?? "N/A"

        cell.textLabel?.text = shop.name
        cell.detailTextLabel?.text = """
        CR: \(shop.crNumber), Building: \(shop.building), Road: \(shop.road), Block: \(shop.block)
        Operating Hours: \(openingTime) - \(closingTime)
        """
        cell.accessoryType = .disclosureIndicator
        return cell
    }


    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Delete"
    }
    
    @IBAction func addShopButtonTapped(_ sender: UIBarButtonItem) {
        // Code to present AddShopController (handled via segue in storyboard)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let shopToDelete = shops[indexPath.row]

            // Query Firestore for the document to delete
            db.collection("Stores").whereField("name", isEqualTo: shopToDelete.name).getDocuments { snapshot, error in
                if let error = error {
                    print("Error finding document to delete: \(error)")
                    return
                }
                guard let document = snapshot?.documents.first else {
                    print("No matching document found for shop: \(shopToDelete.name)")
                    return
                }

                // Delete the document
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    } else {
                        print("Firestore document successfully deleted")

                        // Remove the shop locally
                        self.shops.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func unwindToShopList(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddShopController,
           let newShop = sourceVC.newShop {
            shops.append(newShop)
            tableView.reloadData()
            print("Shop Added: The shop has been added successfully.")
        } else if let sourceVC = segue.source as? EditShopController,
                  let updatedShop = sourceVC.updatedShop,
                  let index = sourceVC.shopIndex {
            shops[index] = updatedShop
            tableView.reloadData()
            print("Shop Updated: The shop details have been updated successfully.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditShop",
           let destinationVC = segue.destination as? EditShopController,
           let indexPath = tableView.indexPathForSelectedRow {
            
            let shop = shops[indexPath.row]
            destinationVC.shopToEdit = shop
            destinationVC.shopIndex = indexPath.row
        }
    }
}
