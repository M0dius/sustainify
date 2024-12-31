import UIKit
import FirebaseFirestore


class AddShopController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let db = Firestore.firestore()

    
    // IBOutlets for text fields
    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tCRNumber: UITextField!
    @IBOutlet weak var tBuilding: UITextField!
    @IBOutlet weak var tRoad: UITextField!
    @IBOutlet weak var tBlock: UITextField!
    @IBOutlet weak var tDescription: UITextField!

    @IBOutlet weak var tMinimumOrderAmount: UITextField!  // Text field for Minimum Order Amount
    
    @IBOutlet weak var addShopButton: UIButton!
    
    @IBOutlet weak var openingTimeValueLabel: UILabel!
    @IBOutlet weak var closingTimeValueLabel: UILabel!
    
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
    
    var newShop: Shop?
    var openingTime: String? // Changed from Date? to String?
    var closingTime: String? // Changed from Date? to String?
    
    // Store categories
    let storeCategories = ["Food", "Clothes", "Electronics", "Furniture", "Accessories", "Misc"]
    var selectedStoreCategories = [String]()
    
    // Payment options
    var selectedPaymentOptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStoreCategorySelection()
    }
    
    @IBAction func addShopButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let minimumOrderAmount = Double(tMinimumOrderAmount.text ?? "0") ?? 0.0

            // Gather selected payment options
            selectedPaymentOptions = []
            if switchCash.isOn { selectedPaymentOptions.append("Cash") }
            if switchBenefit.isOn { selectedPaymentOptions.append("Benefit") }
            if switchOnlinePayment.isOn { selectedPaymentOptions.append("Online Payment (Debit/Credit Card)") }

            // Prepare the shop data
            let shopData: [String: Any] = [
                "name": tName.text ?? "",
                "description": tDescription.text ?? "", // Add description
                "crNumber": Int(tCRNumber.text!) ?? 0,
                "building": Int(tBuilding.text!) ?? 0,
                "road": Int(tRoad.text!) ?? 0,
                "block": Int(tBlock.text!) ?? 0,
                "minimumOrder": minimumOrderAmount,
                "openingTime": openingTime ?? "",
                "closingTime": closingTime ?? "",
                "paymentOptions": selectedPaymentOptions,
                "storeCategories": selectedStoreCategories
            ]


            // Save the new shop to Firestore
            db.collection("Stores").addDocument(data: shopData) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                    self.showAlert(title: "Error", message: "Failed to add store. Please try again.")
                } else {
                    print("Document added successfully")
                    self.showAlert(title: "Success", message: "Store has been added successfully.")
                    self.navigationController?.popViewController(animated: true)
                }
            }

            // Add to ShopListController if necessary
            if let navigationController = navigationController,
               let shopListController = navigationController.viewControllers.first as? ShopListController {
                let newShop = Shop(
                    name: tName.text ?? "",
                    crNumber: Int(tCRNumber.text!) ?? 0,
                    building: Int(tBuilding.text!) ?? 0,
                    road: Int(tRoad.text!) ?? 0,
                    block: Int(tBlock.text!) ?? 0,
                    openingTime: openingTime, // Directly as String
                    closingTime: closingTime, // Directly as String
                    description: tDescription.text ?? "", // Add description in the correct position
                    minimumOrderAmount: minimumOrderAmount,
                    storeCategories: selectedStoreCategories,
                    storeImage: imgStore.image,
                    paymentOptions: selectedPaymentOptions
                )


                shopListController.shops.append(newShop)
                shopListController.tableView.reloadData()
            }
        } else {
            showAlert(title: "Error", message: "Please fill in all the fields and select at least one payment option.")
        }
    }



    
    // MARK: - Store Category Selection Setup
    
    func setupStoreCategorySelection() {
        for category in storeCategories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.addTarget(self, action: #selector(storeCategoryButtonTapped(_:)), for: .touchUpInside)
            
            button.layer.borderColor = UIColor.systemGreen.cgColor
            button.layer.borderWidth = 1
            button.setTitleColor(.systemGreen, for: .normal)
            button.backgroundColor = .clear
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
    
    // MARK: - Store Image Setup
    
    @IBAction func btnStoreImageTapped(_ sender: Any) {
        showPhotoAlert(sender: sender)
    }
    
    func showPhotoAlert(sender: Any) {
        let alert = UIAlertController(title: "Take Photo From:", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.getPhoto(type: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
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
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            print("Image not found.")
            return
        }
        imgStore.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Time Pickers
    
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
            formatter.dateFormat = "HH:mm" // Format as String

            if tag == 1 {
                self.openingTime = formatter.string(from: datePicker.date) // Store as String
                self.openingTimeValueLabel.text = self.openingTime
            } else if tag == 2 {
                self.closingTime = formatter.string(from: datePicker.date) // Store as String
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
    
    @IBAction func selectTime(_ sender: UITapGestureRecognizer) {
        if let cellTag = sender.view?.tag {
            presentDatePicker(for: cellTag, sourceView: sender.view!)
        }
    }
    
    // MARK: - Form Validation
    
    func isFormValid() -> Bool {
        return !(tName.text?.isEmpty ?? true) &&
               !(tDescription.text?.isEmpty ?? true) && // Validate description
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
