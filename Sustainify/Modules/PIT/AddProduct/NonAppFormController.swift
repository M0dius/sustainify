//
//  NonAppFormController.swift
//  Sustainify
//
//  Created by User on 24/06/1446 AH.
//

import UIKit

protocol CategoryButtonTableCellDelegate {
    func didToggleCategory(_ category: CategoryName)
}

class NonAppFormController: UITableViewController, CategoryButtonTableCellDelegate {

    var item: NonAppItem? {
        didSet {
            if let item, isViewLoaded {
                setItem(item)
            }
        }
    }
    var onItemUpdated: ((NonAppItem) -> Void)?
    var navigationTitle = "Add Product"

    // MARK: IBOutlets
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var categoriesRow: CategoryButtonTableCell!
    @IBOutlet weak var foodButton: CategoryButton!
    @IBOutlet weak var drinkButton: CategoryButton!
    @IBOutlet weak var makeupButton: CategoryButton!
    @IBOutlet weak var toiletriesButton: CategoryButton!
    @IBOutlet weak var clothingButton: CategoryButton!
    @IBOutlet weak var otherButton: CategoryButton!
    @IBOutlet weak var electronicsButton: CategoryButton!
    @IBOutlet weak var co2EcoTagButton: EcoTagButton!
    @IBOutlet weak var co2EcoTagWeight: UITextField!
    @IBOutlet weak var waterSavedEcoTagButton: EcoTagButton!
    @IBOutlet weak var waterEcoTagWeight: UITextField!
    @IBOutlet weak var recycledMaterialEcoTagButton: EcoTagButton!
    @IBOutlet weak var recycledMaterialEcoTagWeight: UITextField!
    @IBOutlet weak var recycledContainer: UIView!
    @IBOutlet weak var waterSavedContainer: UIView!
    @IBOutlet weak var co2Container: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let item {
            setItem(item)
        }
        setupNavigationBar()
        self.tableView.allowsSelection = false
        self.categoriesRow.delegate = self
        configureTextFields()
        co2Container.alpha = co2EcoTagButton.isButtonSelected ? 1.0 : 0.5
        recycledContainer.alpha = co2EcoTagButton.isButtonSelected ? 1.0 : 0.5
        waterSavedContainer.alpha = co2EcoTagButton.isButtonSelected ? 1.0 : 0.5
    }

    private func setupNavigationBar() {
        self.navigationItem.title = navigationTitle
        let saveButton = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveItem)
        )
        saveButton.setTitleTextAttributes([
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ], for: .normal)
        self.navigationItem.rightBarButtonItem = saveButton
    }

    private func configureTextFields() {
        co2EcoTagWeight.isEnabled = false
        waterEcoTagWeight.isEnabled = false
        recycledMaterialEcoTagWeight.isEnabled = false
    }

    // MARK: - Save Action
    @objc private func saveItem() {
        guard let item else { return }
        onItemUpdated?(item)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Setup Functions
    private func setItem(_ item: NonAppItem) {
        productName.text = item.name
        companyName.text = item.company
        setCategories(item.categories)
        setEcoTags(item.ecoTags)
    }

    func setCategories(_ categories: [CategoryName]) {
        foodButton.setSelected(categories.contains(.food))
        drinkButton.setSelected(categories.contains(.drink))
        makeupButton.setSelected(categories.contains(.makeup))
        toiletriesButton.setSelected(categories.contains(.toiletries))
        clothingButton.setSelected(categories.contains(.clothing))
        otherButton.setSelected(categories.contains(.other))
        electronicsButton.setSelected(categories.contains(.electronics))
    }

    func setEcoTags(_ tags: [EcoTag]) {
        let co2Tag = tags.first(where: { $0.name == .co2Em })
        co2EcoTagButton.setSelected(co2Tag?.applied ?? false)
        co2EcoTagWeight.text = co2Tag?.weight?.description ?? ""
        co2EcoTagWeight.isEnabled = co2Tag?.applied ?? false

        let waterTag = tags.first(where: { $0.name == .h2oSaved })
        waterSavedEcoTagButton.setSelected(waterTag?.applied ?? false)
        waterEcoTagWeight.text = waterTag?.weight?.description ?? ""
        waterEcoTagWeight.isEnabled = waterTag?.applied ?? false

        let recycledTag = tags.first(where: { $0.name == .recyMat })
        recycledMaterialEcoTagButton.setSelected(recycledTag?.applied ?? false)
        recycledMaterialEcoTagWeight.text = recycledTag?.weight?.description ?? ""
        recycledMaterialEcoTagWeight.isEnabled = recycledTag?.applied ?? false
    }

    // MARK: - Basics Section
    @IBAction func productNameChanged(_ sender: UITextField) {
        item?.name = sender.text ?? ""
    }

    @IBAction func companyNameChanged(_ sender: UITextField) {
        item?.company = sender.text ?? ""
    }

    @IBAction func co2WeightChanged(_ sender: UITextField) {
        guard co2EcoTagButton.isButtonSelected, let text = sender.text, let weight = Int(text) else {
            updateEcoTagWeight(.co2Em, weight: nil)
            return
        }
        updateEcoTagWeight(.co2Em, weight: weight)
    }

    @IBAction func waterWeightChanged(_ sender: UITextField) {
        guard waterSavedEcoTagButton.isButtonSelected, let text = sender.text, let weight = Int(text) else {
            updateEcoTagWeight(.h2oSaved, weight: nil)
            return
        }
        updateEcoTagWeight(.h2oSaved, weight: weight)
    }

    @IBAction func recycledWeightChanged(_ sender: UITextField) {
        guard recycledMaterialEcoTagButton.isButtonSelected, let text = sender.text, let weight = Int(text) else {
            updateEcoTagWeight(.recyMat, weight: nil)
            return
        }
        updateEcoTagWeight(.recyMat, weight: weight)
    }

    private func updateEcoTagWeight(_ tagName: TagName, weight: Int?) {
        guard let item else { return }
        if let index = item.ecoTags.firstIndex(where: { $0.name == tagName }) {
            item.ecoTags[index].weight = weight
        } else {
            item.ecoTags.append(EcoTag(applied: false, name: tagName, weight: weight))
        }
        setEcoTags(item.ecoTags)
    }

    // MARK: - EcoTag Toggle Actions
    @IBAction func co2Toggled(_ sender: UIButton) {
        let isSelected = !co2EcoTagButton.isButtonSelected
        toggleEcoTag(EcoTag(
            applied: isSelected,
            name: .co2Em,
            weight: isSelected ? Int(co2EcoTagWeight.text ?? "") : nil
        ))
        co2EcoTagWeight.isEnabled = isSelected
        co2Container.alpha = isSelected ? 1.0 : 0.5
        if !isSelected { co2EcoTagWeight.text = "" }
    }

    @IBAction func waterToggled(_ sender: UIButton) {
        let isSelected = !waterSavedEcoTagButton.isButtonSelected
        toggleEcoTag(EcoTag(
            applied: isSelected,
            name: .h2oSaved,
            weight: isSelected ? Int(waterEcoTagWeight.text ?? "") : nil
        ))
        waterEcoTagWeight.isEnabled = isSelected
        waterSavedContainer.alpha = isSelected ? 1.0 : 0.5
        if !isSelected { waterEcoTagWeight.text = "" }
    }

    @IBAction func recycledToggled(_ sender: UIButton) {
        let isSelected = !recycledMaterialEcoTagButton.isButtonSelected
        toggleEcoTag(EcoTag(
            applied: isSelected,
            name: .recyMat,
            weight: isSelected ? Int(recycledMaterialEcoTagWeight.text ?? "") : nil
        ))
        recycledMaterialEcoTagWeight.isEnabled = isSelected
        recycledContainer.alpha = isSelected ? 1.0 : 0.5
        if !isSelected { recycledMaterialEcoTagWeight.text = "" }
    }

    private func toggleEcoTag(_ tag: EcoTag) {
        guard let item else { return }
        if let index = item.ecoTags.firstIndex(where: { $0.name == tag.name }) {
            item.ecoTags[index] = tag
        } else {
            item.ecoTags.append(tag)
        }
        setEcoTags(item.ecoTags)
    }

    // MARK: - Category Delegate
    func didToggleCategory(_ category: CategoryName) {
        guard let item else { return }
        if item.categories.contains(category) {
            item.categories.removeAll(where: { $0 == category })
        } else {
            item.categories.append(category)
        }
        setCategories(item.categories)
    }
}

// MARK: - Button Subclasses
class CategoryButton: UIButton {
    private(set) var isButtonSelected = false

    func setSelected(_ selected: Bool) {
        isButtonSelected = selected
        self.configuration?.baseForegroundColor = selected ? .white : .appGreen
        self.configuration?.baseBackgroundColor = selected ? .appGreen : .secondarySystemFill
    }
}

class EcoTagButton: UIButton {
    private(set) var isButtonSelected = false

    func setSelected(_ selected: Bool) {
        isButtonSelected = selected
        self.setImage(
            UIImage(systemName: selected ? "checkmark.circle.fill" : "circle"),
            for: .normal
        )
    }
}

// MARK: - Table Cells
class CategoryButtonTableCell: UITableViewCell {
    var delegate: CategoryButtonTableCellDelegate?

    @IBAction func foodToggled(_ sender: UIButton) { delegate?.didToggleCategory(.food) }
    @IBAction func drinkToggled(_ sender: UIButton) { delegate?.didToggleCategory(.drink) }
    @IBAction func makeupToggled(_ sender: UIButton) { delegate?.didToggleCategory(.makeup) }
    @IBAction func toiletriesToggled(_ sender: UIButton) { delegate?.didToggleCategory(.toiletries) }
    @IBAction func clothingToggled(_ sender: UIButton) { delegate?.didToggleCategory(.clothing) }
    @IBAction func otherToggled(_ sender: UIButton) { delegate?.didToggleCategory(.other) }
    @IBAction func electronicsToggled(_ sender: UIButton) { delegate?.didToggleCategory(.electronics) }
}
