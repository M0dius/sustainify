import UIKit

class EditShopController: UITableViewController {

    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tLocation: UITextField!
    @IBOutlet weak var tDescription: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var shopToEdit: Shop?
    var shopIndex: Int?
    var updatedShop: Shop?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let shop = shopToEdit {
            tName.text = shop.name
            tLocation.text = shop.location
            tDescription.text = shop.description
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            // Create updated shop
            let updatedShop = Shop(
                name: tName.text!,
                location: tLocation.text!,
                description: tDescription.text!
            )
            
            // Update the shop in the shop list (assuming ShopListController is the root controller)
            if let navigationController = navigationController,
               let shopListController = navigationController.viewControllers.first as? ShopListController,
               let shopIndex = shopIndex {
                shopListController.shops[shopIndex] = updatedShop
                shopListController.tableView.reloadData()
                showAlert(title: "Success", message: "Shop details have been updated successfully.")
                navigationController.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Error", message: "Please ensure all fields are filled out correctly.")
        }
    }

    func isFormValid() -> Bool {
        return !(tName.text?.isEmpty ?? true) &&
               !(tLocation.text?.isEmpty ?? true) &&
               !(tDescription.text?.isEmpty ?? true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
