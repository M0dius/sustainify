import UIKit

class DropdownItemCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Round corners if you like:
        // imageView.layer.cornerRadius = 6
        // imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup Layout
    
    private func setupViews() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            // Item image, pinned left
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 40),
            itemImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Name label, to the right of the image
            nameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Price label, pinned right
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Make nameLabel not overlap priceLabel
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Public Configure Method
    func configure(itemImage: UIImage?, itemName: String, itemPrice: String) {
        itemImageView.image = itemImage
        nameLabel.text = itemName
        priceLabel.text = itemPrice
    }
}
