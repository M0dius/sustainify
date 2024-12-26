import UIKit

class AddShopController: UITableViewController {

    // Outlets for the text fields
    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tCRNumber: UITextField!
    @IBOutlet weak var tBuilding: UITextField!
    @IBOutlet weak var tRoad: UITextField!
    @IBOutlet weak var tBlock: UITextField!
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
                crNumber: Int(tCRNumber.text!) ?? 0,
                building: Int(tBuilding.text!) ?? 0,
                road: Int(tRoad.text!) ?? 0,
                block: Int(tBlock.text!) ?? 0
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

    func isFormValid() -> Bool {
        return !(tName.text?.isEmpty ?? true) &&
               !(tCRNumber.text?.isEmpty ?? true) &&
               Int(tCRNumber.text!) != nil &&
               !(tBuilding.text?.isEmpty ?? true) &&
               Int(tBuilding.text!) != nil &&
               !(tRoad.text?.isEmpty ?? true) &&
               Int(tRoad.text!) != nil &&
               !(tBlock.text?.isEmpty ?? true) &&
               Int(tBlock.text!) != nil
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
