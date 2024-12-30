import UIKit
import FirebaseFirestore


class EditShopController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let db = Firestore.firestore()

    
    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tCRNumber: UITextField!
    @IBOutlet weak var tBuilding: UITextField!
    @IBOutlet weak var tRoad: UITextField!
    @IBOutlet weak var tBlock: UITextField!
    @IBOutlet weak var tDescription: UITextField!

    @IBOutlet weak var tMinimumOrderAmount: UITextField!

    @IBOutlet weak var openingTimeValueLabel: UILabel!
    @IBOutlet weak var closingTimeValueLabel: UILabel!

    @IBOutlet weak var saveButton: UIButton!

    // Outlets for store categories
    @IBOutlet weak var storeCategoriesScrollView: UIScrollView!
    @IBOutlet weak var storeCategoriesStackView: UIStackView!

    // Outlets for store image
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var btnStoreImage: UIButton!

    // Outlets for Payment Option Switches
    @IBOutlet weak var switchCash: UISwitch!
    @IBOutlet weak var switchBenefit: UISwitch!
    @IBOutlet weak var switchOnlinePayment: UISwitch!

    var shopToEdit: Shop?
    var shopIndex: Int?
    var updatedShop: Shop?

    var openingTime: String? // Changed from Date? to String?
    var closingTime: String? // Changed from Date? to String?
    var selectedPaymentOptions = [String]()


    // Store categories
    let storeCategories = ["Food", "Clothes", "Electronics", "Furniture", "Accessories", "Misc"]
    var selectedStoreCategories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let shop = shopToEdit {
            tName.text = shop.name
            tCRNumber.text = String(shop.crNumber)
            tBuilding.text = String(shop.building)
            tRoad.text = String(shop.road)
            tBlock.text = String(shop.block)
            tMinimumOrderAmount.text = shop.minimumOrderAmount != nil ? String(shop.minimumOrderAmount!) : ""

            // Display opening and closing times as strings
            openingTime = shop.openingTime
            closingTime = shop.closingTime
            openingTimeValueLabel.text = openingTime ?? "N/A"
            closingTimeValueLabel.text = closingTime ?? "N/A"

            // Pre-fill the description field
            tDescription.text = shop.description ?? "" // Add this line

            selectedStoreCategories = shop.storeCategories
            imgStore.image = shop.storeImage

            // Initialize payment option switches
            switchCash.isOn = shop.paymentOptions.contains("Cash")
            switchBenefit.isOn = shop.paymentOptions.contains("Benefit")
            switchOnlinePayment.isOn = shop.paymentOptions.contains("Online Payment (Debit/Credit Card)")
        }

        setupStoreCategorySelection()
    }




    // MARK: - Store Category Selection

    func setupStoreCategorySelection() {
        for category in storeCategories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.addTarget(self, action: #selector(storeCategoryButtonTapped(_:)), for: .touchUpInside)

            if selectedStoreCategories.contains(category) {
                button.backgroundColor = .systemGreen
                button.setTitleColor(.white, for: .normal)
                button.layer.borderWidth = 0
            } else {
                button.layer.borderColor = UIColor.systemGreen.cgColor
                button.layer.borderWidth = 1
                button.setTitleColor(.systemGreen, for: .normal)
                button.backgroundColor = .clear
            }
            button.layer.cornerRadius = 5
//            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            button.widthAnchor.constraint(equalToConstant: 120).isActive = true

            storeCategoriesStackView.addArrangedSubview(button)
        }

        DispatchQueue.main.async {
            self.storeCategoriesScrollView.contentSize = CGSize(
                width: self.storeCategoriesStackView.frame.width,
                height: self.storeCategoriesStackView.frame.height
            )
        }
        storeCategoriesScrollView.isScrollEnabled = true
    }

    @objc func storeCategoryButtonTapped(_ sender: UIButton) {
        guard let category = sender.titleLabel?.text else { return }
        if selectedStoreCategories.contains(category) {
            selectedStoreCategories.removeAll { $0 == category }
            sender.layer.borderColor = UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 1
            sender.setTitleColor(.systemGreen, for: .normal)
            sender.backgroundColor = .clear
        } else {
            selectedStoreCategories.append(category)
            sender.backgroundColor = .systemGreen
            sender.setTitleColor(.white, for: .normal)
            sender.layer.borderWidth = 0
        }
    }

    @IBAction func selectTime(_ sender: UITapGestureRecognizer) {
        if let cellTag = sender.view?.tag {
            presentDatePicker(for: cellTag, sourceView: sender.view!)
        }
    }

    func presentDatePicker(for tag: Int, sourceView: UIView) {
        let alert = UIAlertController(title: "Select Time", message: nil, preferredStyle: .actionSheet)

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels

        alert.view.addSubview(datePicker)

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -110).isActive = true

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            if tag == 1 {
                self.openingTime = formatter.string(from: datePicker.date)
                self.openingTimeValueLabel.text = self.openingTime
            } else if tag == 2 {
                self.closingTime = formatter.string(from: datePicker.date)
                self.closingTimeValueLabel.text = self.closingTime
            }
        }))

        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceView.bounds
            popoverController.permittedArrowDirections = [.up, .down]
        }

        present(alert, animated: true, completion: nil)
    }

    

    // MARK: - Store Image

    @IBAction func btnStoreImageTapped(_ sender: Any) {
        showPhotoAlert(sender: sender)
    }

    func showPhotoAlert(sender: Any) {
        let alert = UIAlertController(title: "Take Photo From:", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.getPhoto(type: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.getPhoto(type: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let popoverController = alert.popoverPresentationController,
           let viewForSource = sender as? UIView {
            popoverController.sourceView = viewForSource
            popoverController.sourceRect = viewForSource.bounds
            popoverController.permittedArrowDirections = .any
        }

        present(alert, animated: true, completion: nil)
    }

    func getPhoto(type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            print("Image not found")
            return
        }
        imgStore.image = image
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Save

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let minimumOrderAmount = Double(tMinimumOrderAmount.text ?? "0") ?? 0.0

            // Gather selected payment options
            selectedPaymentOptions = []
            if switchCash.isOn { selectedPaymentOptions.append("Cash") }
            if switchBenefit.isOn { selectedPaymentOptions.append("Benefit") }
            if switchOnlinePayment.isOn { selectedPaymentOptions.append("Online Payment (Debit/Credit Card)") }

            // Create updated shop object
            let updatedShop = Shop(
                name: tName.text!,
                crNumber: Int(tCRNumber.text!) ?? 0,
                building: Int(tBuilding.text!) ?? 0,
                road: Int(tRoad.text!) ?? 0,
                block: Int(tBlock.text!) ?? 0,
                openingTime: openingTime, // Stored as String
                closingTime: closingTime, // Stored as String
                description: tDescription.text ?? "", // Add description
                minimumOrderAmount: minimumOrderAmount,
                storeCategories: selectedStoreCategories,
                storeImage: imgStore.image,
                paymentOptions: selectedPaymentOptions
            )

            if let shopIndex = shopIndex,
               let navigationController = navigationController,
               let shopListController = navigationController.viewControllers.first as? ShopListController {

                // Update Firestore document
                let shopDocument = shopListController.shops[shopIndex]
                db.collection("Stores").whereField("name", isEqualTo: shopDocument.name).getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching document to update: \(error)")
                        return
                    }
                    guard let document = snapshot?.documents.first else {
                        print("No document found for shop \(shopDocument.name)")
                        return
                    }

                    document.reference.updateData([
                        "name": updatedShop.name,
                        "crNumber": updatedShop.crNumber,
                        "building": updatedShop.building,
                        "road": updatedShop.road,
                        "block": updatedShop.block,
                        "description": updatedShop.description ?? "", // Add description
                        "minimumOrder": updatedShop.minimumOrderAmount ?? 0,
                        "openingTime": updatedShop.openingTime ?? "",
                        "closingTime": updatedShop.closingTime ?? "",
                        "paymentOptions": updatedShop.paymentOptions,
                        "storeCategories": updatedShop.storeCategories
                    ]) { error in
                        if let error = error {
                            print("Error updating Firestore document: \(error)")
                        } else {
                            print("Firestore document successfully updated")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }

                // Update local data and UI
                shopListController.shops[shopIndex] = updatedShop
                shopListController.tableView.reloadData()
                showAlert(title: "Success", message: "Shop details have been updated successfully.")
            }
        } else {
            showAlert(title: "Error", message: "Please ensure all fields and at least one payment option are selected.")
        }
    }



    // MARK: - Helpers

    func getSelectedPaymentOptions() -> [String] {
        var options = [String]()
        if switchCash.isOn {
            options.append("Cash")
        }
        if switchBenefit.isOn {
            options.append("Benefit")
        }
        if switchOnlinePayment.isOn {
            options.append("Online Payment (Debit/Credit Card)")
        }
        return options
    }

    func isFormValid() -> Bool {
        return !(tName.text?.isEmpty ?? true) &&
               !(tCRNumber.text?.isEmpty ?? true) && Int(tCRNumber.text!) != nil &&
               !(tBuilding.text?.isEmpty ?? true) && Int(tBuilding.text!) != nil &&
               !(tRoad.text?.isEmpty ?? true) && Int(tRoad.text!) != nil &&
               !(tBlock.text?.isEmpty ?? true) && Int(tBlock.text!) != nil &&
               (switchCash.isOn || switchBenefit.isOn || switchOnlinePayment.isOn)
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
