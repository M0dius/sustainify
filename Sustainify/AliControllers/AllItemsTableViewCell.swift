import UIKit

class AllItemsTableViewCell: UITableViewCell,
                             UITableViewDataSource,
                             UITableViewDelegate {
    
    // Horizontal scroll for category buttons
    private let categoryScrollView = UIScrollView()
    private let categoryStack = UIStackView()
    
    // Title label: "All Items"
    private let titleLabel = UILabel()
    
    // A nested table view for listing all items
    private let itemsTableView = UITableView()
    
    // Categories for buttons
    private let categories = ["All", "Food", "Drinks", "Makeup", "Clothing", "Toiletries", "Electronics"]
    
    // Full store items vs. filtered items
    private var allItems: [StoreItem] = []
    private var filteredItems: [StoreItem] = []
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Title
        titleLabel.text = "All Items"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Category scroll
        categoryScrollView.showsHorizontalScrollIndicator = true
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Category stack
        categoryStack.axis = .horizontal
        categoryStack.spacing = 8    // small gap between each button
        categoryStack.alignment = .center
        categoryStack.distribution = .equalSpacing
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Build the category buttons with a filled style
        for cat in categories {
            let button = UIButton(type: .system)
            
            // Create a filled configuration
            var config = UIButton.Configuration.filled()
            config.title = cat
            config.cornerStyle = .medium
            config.baseBackgroundColor = .systemBlue   // fill color
            config.baseForegroundColor = .white        // text color
            
            button.configuration = config
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            
            categoryStack.addArrangedSubview(button)
        }
        
        // Items table
        itemsTableView.translatesAutoresizingMaskIntoConstraints = false
        itemsTableView.isScrollEnabled = false   // parent scroll controls vertical
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.rowHeight = 60
        itemsTableView.register(AllItemsSubCell.self,
                                forCellReuseIdentifier: "allItemsSubCell")
        
        // Add subviews
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStack)
        contentView.addSubview(itemsTableView)
        
        // Layout
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Category scroll
            categoryScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            categoryScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            categoryStack.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStack.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStack.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStack.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            
            // Items table
            itemsTableView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 10),
            itemsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    /// Called from StoreDetailsViewController to pass all store items
    func configure(with items: [StoreItem]) {
        allItems = items
        filteredItems = items
        itemsTableView.reloadData()
    }
    
    // MARK: - Category Buttons
    @objc private func categoryTapped(_ sender: UIButton) {
        guard let catName = sender.configuration?.title else { return }
        
        if catName == "All" {
            filteredItems = allItems
        } else {
            filteredItems = allItems.filter { $0.category == catName }
        }
        itemsTableView.reloadData()
        
        // After reloading the table, we want the parent table to recalc height.
        // If you have a reference to the parent table, you can do:
        // (superview as? UITableView)?.beginUpdates()
        // (superview as? UITableView)?.endUpdates()
        // Or the store details VC might handle it.
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "allItemsSubCell",
            for: indexPath
        ) as! AllItemsSubCell
        cell.configure(with: filteredItems[indexPath.row])
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tappedItem = filteredItems[indexPath.row]
        print("Tapped item: \(tappedItem.name)")
        // Possibly navigate or do something with the tapped item
    }
    
    // MARK: - Self-Sizing Trick for Nested Table
    /// This method helps iOS figure out the correct cell height
    /// so the entire content is visible without bouncing.
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        // 1) Let the sub-table calculate its content size
        itemsTableView.layoutIfNeeded()
        
        // 2) Sum up all the vertical space:
        //    - Title label
        //    - Category scroll
        //    - Gap
        //    - The table’s content height
        let tableHeight = itemsTableView.contentSize.height
        let topInset: CGFloat = 10  // from title top
        let spacingBelowTitle: CGFloat = 10
        let spacingBelowCategory: CGFloat = 10
        let bottomInset: CGFloat = 10
        
        // We can measure the dynamic heights from frames if we want:
        let titleHeight = titleLabel.intrinsicContentSize.height
        let categoryHeight: CGFloat = 40
        
        let totalHeight = topInset
            + titleHeight
            + spacingBelowTitle
            + categoryHeight
            + spacingBelowCategory
            + tableHeight
            + bottomInset
        
        // The width can remain whatever we’re given or a fixed value
        let finalWidth = targetSize.width
        return CGSize(width: finalWidth, height: totalHeight)
    }
}

/// The sub-cell used in itemsTableView (image left, bold name & price in middle, underlined category on right)
private class AllItemsSubCell: UITableViewCell {
    
    private let itemImageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let categoryLabel = UILabel()
    
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
        itemImageView.layer.cornerRadius = 10
        itemImageView.clipsToBounds = true
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        priceLabel.textColor = .darkGray
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 12)
        categoryLabel.textColor = .systemBlue
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 50),
            itemImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: categoryLabel.leadingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: StoreItem) {
        if let realImage = UIImage(named: item.imageName) {
            itemImageView.image = realImage
        } else {
            itemImageView.image = UIImage(named: "PlaceholderImage")
        }
        
        nameLabel.text = item.name
        priceLabel.text = item.price
        
        // Underline the category text
        let underlineCat = NSAttributedString(
            string: item.category,
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        categoryLabel.attributedText = underlineCat
    }
}
