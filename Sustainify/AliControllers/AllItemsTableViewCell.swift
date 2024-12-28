import UIKit

protocol AllItemsTableViewCellDelegate: AnyObject {
    /// Called when user taps a product row
    func didSelectItem(_ item: StoreItem)
}

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
    
    // Delegate to pass item taps back to StoreDetailsViewController
    weak var delegate: AllItemsTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Title
        titleLabel.text = "All Items"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryScrollView.showsHorizontalScrollIndicator = true
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        categoryStack.axis = .horizontal
        categoryStack.spacing = -30
        categoryStack.alignment = .center
        categoryStack.distribution = .equalSpacing
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Build the category buttons
        for cat in categories {
            let button = UIButton(type: .system)
            var config = UIButton.Configuration.filled()
            config.title = cat
            config.cornerStyle = .medium
            config.baseBackgroundColor = .systemBlue
            config.baseForegroundColor = .white
            
            button.configuration = config
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            categoryStack.addArrangedSubview(button)
        }
        
        itemsTableView.translatesAutoresizingMaskIntoConstraints = false
        itemsTableView.isScrollEnabled = false
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.rowHeight = 60
        itemsTableView.register(AllItemsSubCell.self, forCellReuseIdentifier: "allItemsSubCell")
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStack)
        contentView.addSubview(itemsTableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            categoryScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            categoryStack.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStack.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStack.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStack.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            
            itemsTableView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 10),
            itemsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with items: [StoreItem]) {
        allItems = items
        filteredItems = items
        itemsTableView.reloadData()
    }
    
    @objc private func categoryTapped(_ sender: UIButton) {
        guard let catName = sender.configuration?.title else { return }
        
        if catName == "All" {
            filteredItems = allItems
        } else {
            filteredItems = allItems.filter { $0.category == catName }
        }
        itemsTableView.reloadData()
    }
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allItemsSubCell",
                                                 for: indexPath) as! AllItemsSubCell
        cell.configure(with: filteredItems[indexPath.row])
        return cell
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tappedItem = filteredItems[indexPath.row]
        
        // Notify our delegate (the StoreDetailsViewController) to show the popup
        delegate?.didSelectItem(tappedItem)
    }
}

/// The sub-cell used in itemsTableView
private class AllItemsSubCell: UITableViewCell {
    
    private let itemImageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let categoryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        
        let underlineCat = NSAttributedString(
            string: item.category,
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        categoryLabel.attributedText = underlineCat
    }
}
