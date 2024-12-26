import UIKit

class AddShopController: UITableViewController {

    // Outlets for the text fields
    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tLocation: UITextField!
    @IBOutlet weak var tDescription: UITextField!
    @IBOutlet weak var addShopButton: UIButton!

    var newShop: Shop?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addShopButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            // Create new shop
            let newShop = Shop(
                name: tName.text!,
                location: tLocation.text!,
                description: tDescription.text!
            )
            
            // Add the new shop to the shop list (assuming ShopListController is the root controller)
            if let navigationController = navigationController,
               let shopListController = navigationController.viewControllers.first as? ShopListController {
                shopListController.shops.append(newShop)
                shopListController.tableView.reloadData()
                showAlert(title: "Success", message: "Shop has been added successfully.")
                navigationController.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Error", message: "Please fill in all the fields with valid data.")
        }
    }

    func segueToShopList() {
        performSegue(withIdentifier: "unwindToShopList", sender: self)
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
