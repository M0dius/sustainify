import UIKit

class EditShopController: UITableViewController {

    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tCRNumber: UITextField!
    @IBOutlet weak var tBuilding: UITextField!
    @IBOutlet weak var tRoad: UITextField!
    @IBOutlet weak var tBlock: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var shopToEdit: Shop?
    var shopIndex: Int?
    var updatedShop: Shop?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let shop = shopToEdit {
            tName.text = shop.name
            tCRNumber.text = String(shop.crNumber)
            tBuilding.text = String(shop.building)
            tRoad.text = String(shop.road)
            tBlock.text = String(shop.block)
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            // Create updated shop
            let updatedShop = Shop(
                name: tName.text!,
                crNumber: Int(tCRNumber.text!) ?? 0,
                building: Int(tBuilding.text!) ?? 0,
                road: Int(tRoad.text!) ?? 0,
                block: Int(tBlock.text!) ?? 0
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
