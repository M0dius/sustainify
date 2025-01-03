import UIKit

class DropdownItemCell: UITableViewCell {
    
    private let itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
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
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8
            ),
            itemImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            itemImageView.widthAnchor.constraint(equalToConstant: 40),
            itemImageView.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.leadingAnchor.constraint(
                equalTo: itemImageView.trailingAnchor,
                constant: 8
            ),
            nameLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            
            priceLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            priceLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            
            nameLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: priceLabel.leadingAnchor,
                constant: -8
            )
        ])
    }
    
    func configure(itemImage: UIImage?, itemName: String, itemPrice: String) {
        itemImageView.image = itemImage
        nameLabel.text = itemName
        priceLabel.text = itemPrice
    }
}
