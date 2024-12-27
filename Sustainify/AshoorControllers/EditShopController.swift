import UIKit

class EditShopController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tCRNumber: UITextField!
    @IBOutlet weak var tBuilding: UITextField!
    @IBOutlet weak var tRoad: UITextField!
    @IBOutlet weak var tBlock: UITextField!
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

    var openingTime: Date?
    var closingTime: Date?

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
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
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

            let updatedShop = Shop(
                name: tName.text!,
                crNumber: Int(tCRNumber.text!) ?? 0,
                building: Int(tBuilding.text!) ?? 0,
                road: Int(tRoad.text!) ?? 0,
                block: Int(tBlock.text!) ?? 0,
                openingTime: openingTime,
                closingTime: closingTime,
                minimumOrderAmount: minimumOrderAmount,
                storeCategories: selectedStoreCategories,
                storeImage: imgStore.image,
                paymentOptions: getSelectedPaymentOptions()
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
