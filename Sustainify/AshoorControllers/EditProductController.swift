import UIKit

class EditProductController: UITableViewController {

    let categories = ["Food", "Drinks", "Makeup", "Toiletries", "Clothing", "Electronic", "Others"]
    var selectedCategories = [String]()
    var productToEdit: Product?
    var productIndex: Int?
    var updatedProduct: Product?
    var ecoTags: [EcoTagModel] = []

    @IBOutlet weak var tName: UITextField!
    @IBOutlet weak var tCompany: UITextField!
    @IBOutlet weak var tPrice: UITextField!
    @IBOutlet weak var tDescription: UITextField!
    @IBOutlet weak var tEcoScore: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var switchCO2e: UISwitch!
    @IBOutlet weak var textFieldCO2e: UITextField!
    @IBOutlet weak var switchWaterSaved: UISwitch!
    @IBOutlet weak var textFieldWaterSaved: UITextField!
    @IBOutlet weak var switchRecycledMaterial: UISwitch!
    @IBOutlet weak var textFieldRecycledMaterial: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let product = productToEdit {
            tName.text = product.name
            tCompany.text = product.company
            tPrice.text = String(product.price)
            tDescription.text = product.description
            tEcoScore.text = String(product.ecoScore)
            selectedCategories = product.categories
            ecoTags = product.ecoTags

            // Update Eco-Tag switches and text fields based on product data
            for tag in ecoTags {
                switch tag.tag {
                case .CO2ePer100g:
                    switchCO2e.isOn = tag.value != nil
                    textFieldCO2e.text = tag.value
                case .waterSaved:
                    switchWaterSaved.isOn = tag.value != nil
                    textFieldWaterSaved.text = tag.value
                case .recycledMaterial:
                    switchRecycledMaterial.isOn = tag.value != nil
                    textFieldRecycledMaterial.text = tag.value
                }
            }
        }

        setupCategorySelection()
    }

    func setupCategorySelection() {
        for category in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            
            // Customize the button appearance
            if selectedCategories.contains(category) {
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
            stackView.addArrangedSubview(button)
        }
        
        DispatchQueue.main.async {
            self.scrollView.contentSize = CGSize(width: self.stackView.frame.width, height: self.stackView.frame.height)
        }
        scrollView.isScrollEnabled = true
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

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            let co2eValue = switchCO2e.isOn ? textFieldCO2e.text : nil
            let waterSavedValue = switchWaterSaved.isOn ? textFieldWaterSaved.text : nil
            let recycledMaterialValue = switchRecycledMaterial.isOn ? textFieldRecycledMaterial.text : nil

            ecoTags = [
                EcoTagModel(tag: .CO2ePer100g, value: co2eValue),
                EcoTagModel(tag: .waterSaved, value: waterSavedValue),
                EcoTagModel(tag: .recycledMaterial, value: recycledMaterialValue)
            ]

            updatedProduct = Product(
                name: tName.text!,
                company: tCompany.text!,
                price: Double(tPrice.text!) ?? 0.0,
                description: tDescription.text!,
                ecoScore: Int(tEcoScore.text!) ?? 0,
                categories: selectedCategories,
                ecoTags: ecoTags
            )
            
            if let navigationController = navigationController,
               let productListController = navigationController.viewControllers.first as? ProductListController,
               let productIndex = productIndex {
                productListController.products[productIndex] = updatedProduct!
                productListController.tableView.reloadData()
                showAlert(title: "Success", message: "Product details have been updated successfully.")
                navigationController.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Error", message: "Please ensure all fields are filled out correctly.")
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