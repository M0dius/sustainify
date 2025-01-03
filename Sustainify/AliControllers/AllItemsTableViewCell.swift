import UIKit

protocol AllItemsTableViewCellDelegate: AnyObject {
    func didSelectItem(_ item: StoreItem)
}

class AllItemsTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    private let categoryScrollView = UIScrollView()
    private let categoryStack = UIStackView()
    private let titleLabel = UILabel()
    private let itemsTableView = UITableView()
    private let categories = ["All", "Food", "Drinks", "Makeup", "Clothing", "Toiletries", "Electronics"]
    private var allItems: [StoreItem] = []
    private var filteredItems: [StoreItem] = []
    weak var delegate: AllItemsTableViewCellDelegate?
    
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
        
        for cat in categories {
            let button = UIButton(type: .system)
            var config = UIButton.Configuration.filled()
            config.title = cat
            config.cornerStyle = .medium
            config.baseBackgroundColor = UIColor(red: 43/255.0, green: 158/255.0, blue: 13/255.0, alpha: 1.0)
            config.baseForegroundColor = .white
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            
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
            categoryStack.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor),
            
            itemsTableView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 10),
            itemsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Configuration
    func configure(with items: [StoreItem]) {
        allItems = items
        filteredItems = items
        itemsTableView.reloadData()
    }
    
    // MARK: - Category Button Action
    @objc private func categoryTapped(_ sender: UIButton) {
        guard let catName = sender.configuration?.title else { return }
        
        if catName == "All" {
            filteredItems = allItems
        } else {
            filteredItems = allItems.filter { $0.category == catName }
        }
        itemsTableView.reloadData()
        
        if let tableView = self.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allItemsSubCell", for: indexPath) as! AllItemsSubCell
        cell.configure(with: filteredItems[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedItem = filteredItems[indexPath.row]
        delegate?.didSelectItem(tappedItem)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Self-Sizing Trick for Nested Table
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        itemsTableView.layoutIfNeeded()
        
        let tableHeight = itemsTableView.contentSize.height
        let topInset: CGFloat = 10
        let spacingBelowTitle: CGFloat = 10
        let spacingBelowCategory: CGFloat = 10
        let bottomInset: CGFloat = 10
        
        let titleHeight = titleLabel.intrinsicContentSize.height
        let categoryHeight: CGFloat = 40
        let totalHeight = topInset + titleHeight + spacingBelowTitle + categoryHeight + spacingBelowCategory + tableHeight + bottomInset
        
        let finalWidth = targetSize.width
        return CGSize(width: finalWidth, height: totalHeight)
    }
}

// MARK: - AllItemsSubCell

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
