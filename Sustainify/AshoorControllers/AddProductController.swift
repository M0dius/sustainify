import UIKit

class AddProductController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let categories = ["Food", "Drinks", "Makeup", "Toiletries", "Clothing", "Electronic", "Others"]
    var selectedCategories = [String]()
    var ecoTags: [EcoTagModel] = []
    var newProduct: Product?

    // Outlets for the text fields
    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tCompany: UITextField!
    @IBOutlet weak var tPrice: UITextField!
    @IBOutlet weak var tDescription: UITextField!
    @IBOutlet weak var tEcoScore: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addProductButton: UIButton!
    // Outlets for Eco-Tags switches and text fields
    @IBOutlet weak var switchCO2e: UISwitch!
    @IBOutlet weak var textFieldCO2e: UITextField!
    @IBOutlet weak var switchWaterSaved: UISwitch!
    @IBOutlet weak var textFieldWaterSaved: UITextField!
    @IBOutlet weak var switchRecycledMaterial: UISwitch!
    @IBOutlet weak var textFieldRecycledMaterial: UITextField!
    @IBOutlet weak var imgphoto: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategorySelection()
        setupEcoTags()
    }

    @IBAction func btnTakePhoto(_ sender: Any) {
        showPhotoAlert(sender: sender)
    }
    
    // Setup category selection buttons programmatically
    func setupCategorySelection() {
        for category in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            
            // Customize the button appearance for the unselected state
            button.layer.borderColor = UIColor.systemGreen.cgColor
            button.layer.borderWidth = 1
            button.setTitleColor(.systemGreen, for: .normal)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 5
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            button.widthAnchor.constraint(equalToConstant: 120).isActive = true
            
            stackView.addArrangedSubview(button)
        }
        
        DispatchQueue.main.async {
            self.scrollView.contentSize = CGSize(width: self.stackView.frame.width, height: self.stackView.frame.height)
        }
        scrollView.isScrollEnabled = true
    }

    func setupEcoTags() {
        ecoTags = EcoTag.allCases.map { EcoTagModel(tag: $0, value: nil) }
    }
    
    func showPhotoAlert(sender: Any){
        let alert = UIAlertController(title: "Take Photo From: ", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction (UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.getPhoto(type: .camera)
        }))
        
        alert.addAction (UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.getPhoto(type: .photoLibrary)
        }))
        
        alert.addAction (UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // For iPad: Provide location information for the popover
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = (sender as! UIView).bounds
            popoverController.permittedArrowDirections = .any
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func getPhoto(type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            print("Image not found")
            return
        }
        imgphoto.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @objc func categoryButtonTapped(_ sender: UIButton) {
        guard let category = sender.titleLabel?.text else { return }

        if selectedCategories.contains(category) {
            selectedCategories.removeAll { $0 == category }
            sender.layer.borderColor = UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 1
            sender.setTitleColor(.systemGreen, for: .normal)
            sender.backgroundColor = .clear
        } else {
            selectedCategories.append(category)
            sender.backgroundColor = .systemGreen
            sender.setTitleColor(.white, for: .normal)
            sender.layer.borderWidth = 0
        }
    }

    @IBAction func addProductButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let co2eValue = switchCO2e.isOn ? textFieldCO2e.text : nil
            let waterSavedValue = switchWaterSaved.isOn ? textFieldWaterSaved.text : nil
            let recycledMaterialValue = switchRecycledMaterial.isOn ? textFieldRecycledMaterial.text : nil

            ecoTags = [
                EcoTagModel(tag: .CO2ePer100g, value: co2eValue),
                EcoTagModel(tag: .waterSaved, value: waterSavedValue),
                EcoTagModel(tag: .recycledMaterial, value: recycledMaterialValue)
            ]

            newProduct = Product(
                name: tName.text!,
                company: tCompany.text!,
                price: Double(tPrice.text!) ?? 0.0,
                description: tDescription.text!,
                ecoScore: Int(tEcoScore.text!) ?? 0,
                categories: selectedCategories,
                ecoTags: ecoTags,
                image: imgphoto.image  // Include the image when creating the new product
            )
            
            if let navigationController = navigationController,
               let productListController = navigationController.viewControllers.first as? ProductListController {
                productListController.products.append(newProduct!)
                productListController.tableView.reloadData()
                showAlert(title: "Success", message: "Product has been added successfully.")
                navigationController.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Error", message: "Please fill in all the fields with valid data.")
        }
    }

    func isFormValid() -> Bool {
        return !(tName.text?.isEmpty ?? true) &&
               !(tCompany.text?.isEmpty ?? true) &&
               !(tPrice.text?.isEmpty ?? true) &&
               Double(tPrice.text!) != nil &&
               !(tDescription.text?.isEmpty ?? true) &&
               !(tEcoScore.text?.isEmpty ?? true) &&
               Int(tEcoScore.text!) != nil
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
