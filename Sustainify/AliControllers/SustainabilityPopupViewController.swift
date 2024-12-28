import UIKit

class SustainabilityPopupViewController: UIViewController,
                                         UITableViewDataSource,
                                         UITableViewDelegate {

    // The original item
    var originalItem: StoreItem!
    // The store to find alternatives
    var store: Store!
    
    private var tableView: UITableView!
    private var pickButton: UIButton!
    private var alternativeButton: UIButton!
    
    // Computed once:
    private var alternativeItems: [StoreItem] = []
    
    // Which alternative is selected?
    private var selectedAlternativeIndex: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Build the alternatives array
        let originalScore = originalItem.sustainabilityScore
        // Filter store.allStoreItems for higher sustainability
        // i.e. lower score, limit to 3
        alternativeItems = store.allStoreItems
            .filter { $0.sustainabilityScore < originalScore && $0.name != originalItem.name }
            .sorted { $0.sustainabilityScore < $1.sustainabilityScore }
            .prefix(3)
            .map { $0 }
        
        setupTableView()
        setupButtons()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register a cell
        tableView.register(SustainabilityPopupCell.self, forCellReuseIdentifier: "popupCell")
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            // We'll leave some space for the buttons
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    private func setupButtons() {
        pickButton = UIButton(type: .system)
        pickButton.setTitle("Your Pick", for: .normal)
        pickButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        pickButton.addTarget(self, action: #selector(didTapPick), for: .touchUpInside)
        pickButton.translatesAutoresizingMaskIntoConstraints = false
        
        alternativeButton = UIButton(type: .system)
        alternativeButton.setTitle("Choose Alternative", for: .normal)
        alternativeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        alternativeButton.isEnabled = false // disable until user picks an alt
        alternativeButton.addTarget(self, action: #selector(didTapAlternative), for: .touchUpInside)
        alternativeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pickButton)
        view.addSubview(alternativeButton)
        
        NSLayoutConstraint.activate([
            pickButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pickButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            pickButton.widthAnchor.constraint(equalToConstant: 140),
            pickButton.heightAnchor.constraint(equalToConstant: 44),
            
            alternativeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            alternativeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            alternativeButton.widthAnchor.constraint(equalToConstant: 160),
            alternativeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapPick() {
        print("✅ User kept their original pick: \(originalItem.name)")
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAlternative() {
        guard let idx = selectedAlternativeIndex else { return }
        let chosenAlt = alternativeItems[idx]
        print("✅ User chose alternative: \(chosenAlt.name)")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        // 0: "Your Pick" (1 row)
        // 1: "Alternatives" (N rows up to 3)
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return alternativeItems.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Your Pick"
        } else {
            return "Alternatives"
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popupCell",
                                                 for: indexPath) as! SustainabilityPopupCell
        if indexPath.section == 0 {
            // Your pick
            cell.configure(with: originalItem, isChosen: false)
        } else {
            let altItem = alternativeItems[indexPath.row]
            let chosen = (indexPath.row == selectedAlternativeIndex)
            cell.configure(with: altItem, isChosen: chosen)
        }
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        // Only allow picking among alternatives
        if indexPath.section == 1 {
            // Set selectedAlternativeIndex
            selectedAlternativeIndex = indexPath.row
            // Enable the "Choose Alternative" button
            alternativeButton.isEnabled = true
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
}

/// A cell that shows an item’s image, sustainability details, and color-coded percentage
private class SustainabilityPopupCell: UITableViewCell {
    
    private let itemImageView = UIImageView()
    private let detailsLabel = UILabel()
    private let sustainabilityLabel = UILabel() // color-coded
    private let mainStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.cornerRadius = 8
        itemImageView.clipsToBounds = true
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        
        detailsLabel.numberOfLines = 0
        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sustainabilityLabel.font = UIFont.boldSystemFont(ofSize: 16)
        sustainabilityLabel.textAlignment = .center
        sustainabilityLabel.translatesAutoresizingMaskIntoConstraints = false
        sustainabilityLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 8
        mainStack.distribution = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        mainStack.addArrangedSubview(itemImageView)
        mainStack.addArrangedSubview(detailsLabel)
        mainStack.addArrangedSubview(sustainabilityLabel)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            itemImageView.widthAnchor.constraint(equalToConstant: 60),
            itemImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(with item: StoreItem, isChosen: Bool) {
        // Image
        itemImageView.image = UIImage(named: item.imageName) ?? UIImage(named: "PlaceholderImage")
        
        // Build the details about how sustainable the product is
        // We have co2Emissions, recyclability, plasticWaste, etc.
        let detailsText = """
        Name: \(item.name)
        Price: \(item.price)
        Category: \(item.category)
        CO₂: \(item.co2Emissions), Recyclable: \(Int(item.recyclability*100))%, Plastic: \(item.plasticWaste)
        """
        detailsLabel.text = detailsText
        
        // Compute a 0..1 "sustainabilityPercentage" = 1 - score
        let rawScore = item.sustainabilityScore
        let percentage = max(0, min(1, 1 - rawScore)) * 100.0
        
        let percentText = String(format: "%.0f%%", percentage)
        sustainabilityLabel.text = percentText
        
        // Color code
        switch percentage {
        case ..<30:
            sustainabilityLabel.textColor = .systemRed
        case 30..<70:
            sustainabilityLabel.textColor = .systemYellow
        default:
            sustainabilityLabel.textColor = .systemGreen
        }
        
        // Show checkmark if chosen
        accessoryType = isChosen ? .checkmark : .none
    }
}
