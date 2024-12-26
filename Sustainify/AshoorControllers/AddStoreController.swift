import UIKit

class AddStoreController: UITableViewController {

    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tLocation: UITextField!
    @IBOutlet weak var tDescription: UITextField!
    @IBOutlet weak var addStoreButton: UIButton!

    var newStore: Store?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addStoreButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let newStore = Store(
                name: tName.text!,
                location: tLocation.text!,
                description: tDescription.text!
            )

            if let navigationController = navigationController,
               let storeListController = navigationController.viewControllers.first as? StoreListController {
                storeListController.stores.append(newStore)
                storeListController.tableView.reloadData()
                showAlert(title: "Success", message: "Store has been added successfully.")
                navigationController.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Error", message: "Please fill in all the fields with valid data.")
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
