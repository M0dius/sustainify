import UIKit

class EditShopController: UITableViewController {

    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tCRNumber: UITextField!
    @IBOutlet weak var tBuilding: UITextField!
    @IBOutlet weak var tRoad: UITextField!
    @IBOutlet weak var tBlock: UITextField!
    @IBOutlet weak var openingTimeValueLabel: UILabel!
    @IBOutlet weak var closingTimeValueLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var shopToEdit: Shop?
    var shopIndex: Int?
    var updatedShop: Shop?
    var openingTime: Date?
    var closingTime: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let shop = shopToEdit {
            tName.text = shop.name
            tCRNumber.text = String(shop.crNumber)
            tBuilding.text = String(shop.building)
            tRoad.text = String(shop.road)
            tBlock.text = String(shop.block)

            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            if let opening = shop.openingTime {
                openingTime = opening
                openingTimeValueLabel.text = formatter.string(from: opening)
            }
            
            if let closing = shop.closingTime {
                closingTime = closing
                closingTimeValueLabel.text = formatter.string(from: closing)
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let updatedShop = Shop(
                name: tName.text!,
                crNumber: Int(tCRNumber.text!) ?? 0,
                building: Int(tBuilding.text!) ?? 0,
                road: Int(tRoad.text!) ?? 0,
                block: Int(tBlock.text!) ?? 0,
                openingTime: openingTime,
                closingTime: closingTime
            )
            
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

    @IBAction func selectTime(_ sender: UITapGestureRecognizer) {
        // Identify which cell was tapped
        let cellTag = sender.view?.tag // Retrieve the tag value
        let alert = UIAlertController(title: "Select Time", message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        alert.view.addSubview(datePicker)
        
        datePicker.frame = CGRect(x: 10, y: 10, width: alert.view.bounds.width - 40, height: 150)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            if cellTag == 1 { // Opening Time Cell
                self.openingTime = datePicker.date
                self.openingTimeValueLabel.text = formatter.string(from: datePicker.date)
            } else if cellTag == 2 { // Closing Time Cell
                self.closingTime = datePicker.date
                self.closingTimeValueLabel.text = formatter.string(from: datePicker.date)
            }
        }))
        
        present(alert, animated: true, completion: nil)
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
