import UIKit

class AddShopController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // IBOutlets for the text fields
    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tCRNumber: UITextField!
    @IBOutlet weak var tBuilding: UITextField!
    @IBOutlet weak var tRoad: UITextField!
    @IBOutlet weak var tBlock: UITextField!
    
    @IBOutlet weak var addShopButton: UIButton!
    
    @IBOutlet weak var openingTimeValueLabel: UILabel!
    @IBOutlet weak var closingTimeValueLabel: UILabel!
    
    // NEW Outlets for store categories
    // You will create a scrollView + stackView (just like in product) for "What does this store sell?"
    @IBOutlet weak var storeCategoriesScrollView: UIScrollView!
    @IBOutlet weak var storeCategoriesStackView: UIStackView!
    
    // NEW Outlets for store image
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var btnStoreImage: UIButton! // a button to trigger camera/photo library
    
    var newShop: Shop?
    var openingTime: Date?
    var closingTime: Date?
    
    // Just an example set of store categories
    let storeCategories = ["Food", "Clothes", "Electronics", "Furniture", "Accessories", "Misc"]
    var selectedStoreCategories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStoreCategorySelection()
    }
    
    @IBAction func addShopButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let newShop = Shop(
                name: tName.text!,
                crNumber: Int(tCRNumber.text!) ?? 0,
                building: Int(tBuilding.text!) ?? 0,
                road: Int(tRoad.text!) ?? 0,
                block: Int(tBlock.text!) ?? 0,
                openingTime: openingTime,
                closingTime: closingTime,
                storeCategories: selectedStoreCategories,
                storeImage: imgStore.image
            )
            
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
    
    // MARK: - Store Category Selection Setup
    
    func setupStoreCategorySelection() {
        // Programmatically create buttons for each possible category
        for category in storeCategories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.addTarget(self, action: #selector(storeCategoryButtonTapped(_:)), for: .touchUpInside)
            
            // Customize appearance
            button.layer.borderColor = UIColor.systemGreen.cgColor
            button.layer.borderWidth = 1
            button.setTitleColor(.systemGreen, for: .normal)
            button.backgroundColor = .clear
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
        guard let category = sender.titleLabel?.text else {
            return
        }
        
        if selectedStoreCategories.contains(category) {
            selectedStoreCategories.removeAll { $0 == category }
            // revert style
            sender.layer.borderColor = UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 1
            sender.setTitleColor(.systemGreen, for: .normal)
            sender.backgroundColor = .clear
        } else {
            selectedStoreCategories.append(category)
            // highlight style
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
    
    // MARK: - Time Pickers (unchanged)
    
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
            formatter.timeStyle = .short
            
            if tag == 1 { // Opening Time Cell
                self.openingTime = datePicker.date
                self.openingTimeValueLabel.text = formatter.string(from: datePicker.date)
            } else if tag == 2 { // Closing Time Cell
                self.closingTime = datePicker.date
                self.closingTimeValueLabel.text = formatter.string(from: datePicker.date)
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
               !(tCRNumber.text?.isEmpty ?? true) && Int(tCRNumber.text!) != nil &&
               !(tBuilding.text?.isEmpty ?? true) && Int(tBuilding.text!) != nil &&
               !(tRoad.text?.isEmpty ?? true) && Int(tRoad.text!) != nil &&
               !(tBlock.text?.isEmpty ?? true) && Int(tBlock.text!) != nil
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
