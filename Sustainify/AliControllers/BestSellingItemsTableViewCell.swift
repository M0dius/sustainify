import UIKit

/// Displays a horizontal scroll of most sustainable items.
class BestSellingItemsTableViewCell: UITableViewCell {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Title label for the section
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Most Sustainable Items" // Updated title
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var items: [StoreItem] = []
    
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
        contentView.addSubview(scrollView)
        scrollView.addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            scrollView.heightAnchor.constraint(equalToConstant: 160),
            
            // Horizontal stack inside scroll view
            horizontalStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    func configure(with sustainableItems: [StoreItem]) {
        // Clear old subviews
        for subview in horizontalStack.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        items = sustainableItems
        
        // For each item, create a "card" with (image + name + price).
        for item in items {
            let itemView = createItemView(for: item)
            horizontalStack.addArrangedSubview(itemView)
        }
    }
    
    private func createItemView(for item: StoreItem) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.alignment = .center
        container.spacing = 4
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: item.imageName)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let nameLabel = UILabel()
        nameLabel.text = item.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textAlignment = .center
        
        let priceLabel = UILabel()
        priceLabel.text = item.price
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        priceLabel.textAlignment = .center
        
        container.addArrangedSubview(imageView)
        container.addArrangedSubview(nameLabel)
        container.addArrangedSubview(priceLabel)
        
        return container
    }
}
