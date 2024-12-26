import UIKit

class EditStoreController: UITableViewController {

    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tLocation: UITextField!
    @IBOutlet weak var tDescription: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    var storeToEdit: Store?
    var storeIndex: Int?
    var updatedStore: Store?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let store = storeToEdit {
            tName.text = store.name
            tLocation.text = store.location
            tDescription.text = store.description
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let updatedStore = Store(
                name: tName.text!,
                location: tLocation.text!,
                description: tDescription.text!
            )

            if let navigationController = navigationController,
               let storeListController = navigationController.viewControllers.first as? StoreListController,
               let storeIndex = storeIndex {
                storeListController.stores[storeIndex] = updatedStore
                storeListController.tableView.reloadData()
                showAlert(title: "Success", message: "Store details have been updated successfully.")
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
