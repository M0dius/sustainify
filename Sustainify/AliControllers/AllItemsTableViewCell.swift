import UIKit

class AllItemsTableViewCell: UITableViewCell,
                             UITableViewDataSource,
                             UITableViewDelegate {
    
    private let categoryScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let categoryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "All Items"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    /// Category buttons:
    private let categories = ["All", "Food", "Drinks", "Makeup", "Clothing", "Toiletries", "Electronics"]
    
    /// Full list of items from the store:
    private var allItems: [StoreItem] = []
    
    /// Filtered items that appear in the table:
    private var filteredItems: [StoreItem] = []
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStack)
        contentView.addSubview(itemsTableView)
        
        // Register the sub-cell for itemsTableView
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.rowHeight = 60
        itemsTableView.register(AllItemsSubCell.self,
                                forCellReuseIdentifier: "allItemsSubCell")
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Horizontal category scroll
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
        
        // Create category buttons
        for cat in categories {
            let button = UIButton(type: .system)
            button.setTitle(cat, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            categoryStack.addArrangedSubview(button)
        }
    }
    
    /// Called from StoreDetailsViewController to load items
    func configure(with items: [StoreItem]) {
        self.allItems = items
        self.filteredItems = items // show all by default
        itemsTableView.reloadData()
    }
    
    @objc private func categoryTapped(_ sender: UIButton) {
        guard let catName = sender.titleLabel?.text else { return }
        
        if catName == "All" {
            filteredItems = allItems
        } else {
            filteredItems = allItems.filter { $0.category == catName }
        }
        itemsTableView.reloadData()
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allItemsSubCell",
                                                 for: indexPath) as! AllItemsSubCell
        let item = filteredItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = filteredItems[indexPath.row]
        print("Tapped item: \(selectedItem.name)")
        // Possibly navigate or show detail
    }
    
    // MARK: - Auto-sizing for nested table
    override func layoutSubviews() {
        super.layoutSubviews()
        itemsTableView.layoutIfNeeded()
        
        var frame = self.frame
        let tableHeight = itemsTableView.contentSize.height
        let totalHeight = titleLabel.frame.height
            + 10
            + categoryScrollView.frame.height
            + 10
            + tableHeight
            + 10
        frame.size.height = max(frame.size.height, totalHeight)
        self.frame = frame
    }
}

/// A separate cell class for each row in the items table:
/// - Image left
/// - Bold name & smaller price in the center
/// - Category on the right (bold & underlined)
class AllItemsSubCell: UITableViewCell {
    
    private let itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .systemBlue
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 50),
            itemImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: categoryLabel.leadingAnchor, constant: -8),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            
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
        
        // Underlined category
        let attString = NSAttributedString(
            string: item.category,
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        categoryLabel.attributedText = attString
    }
}
