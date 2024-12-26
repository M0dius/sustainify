//
//  BestSellingItemsTableViewCell.swift
//  Sustainify
//

import UIKit

/// Displays a horizontal scroll of best-selling items.
/// Each item has a rounded-square image, bold name, and a price below.
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
        stack.spacing = 16   // Subtle gap between items
        stack.alignment = .top
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Title label for the section
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Best Selling Items"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var items: [StoreItem] = []
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
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
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            
            // Scroll View
            scrollView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 10
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),
            scrollView.heightAnchor.constraint(equalToConstant: 160),
            
            // Horizontal stack inside scroll view
            horizontalStack.topAnchor.constraint(
                equalTo: scrollView.topAnchor
            ),
            horizontalStack.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor
            ),
            horizontalStack.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor
            ),
            horizontalStack.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor
            )
        ])
    }
    
    /// Call this to populate the items in the horizontal stack.
    func configure(with bestSellingItems: [StoreItem]) {
        // Clear old subviews
        for subview in horizontalStack.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        items = bestSellingItems
        
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
        
        // Item image
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12 // Rounded corners
        imageView.clipsToBounds = true
        
        // Load image or fallback
        if let loadedImage = UIImage(named: item.imageName) {
            imageView.image = loadedImage
        } else {
            imageView.image = UIImage(named: "PlaceholderImage")
        }
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Name label
        let nameLabel = UILabel()
        nameLabel.text = item.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textAlignment = .center
        
        // Price label
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
