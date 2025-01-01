import UIKit

protocol BestSellingItemsTableViewCellDelegate: AnyObject {
    func didTapSustainableItem(_ item: StoreItem)
}

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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Most Sustainable Items"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var items: [StoreItem] = []
    
    // Delegate to pass taps up
    weak var delegate: BestSellingItemsTableViewCellDelegate?

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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            scrollView.heightAnchor.constraint(equalToConstant: 160),
            
            horizontalStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    func configure(with sustainableItems: [StoreItem]) {
        // Clear old
        for sub in horizontalStack.arrangedSubviews {
            sub.removeFromSuperview()
        }
        items = sustainableItems
        
        for (index, item) in items.enumerated() {
            let itemView = createItemView(for: item, index: index)
            horizontalStack.addArrangedSubview(itemView)
        }
    }
    
    private func createItemView(for item: StoreItem, index: Int) -> UIView {
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
        imageView.image = UIImage(named: item.imageName) ?? UIImage(named: "PlaceholderImage")
        
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
        
        // Add a tap gesture
        container.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleItemTap(_:)))
        container.addGestureRecognizer(tap)
        container.tag = index // store index to identify which item was tapped
        
        return container
    }
    
    @objc private func handleItemTap(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let index = view.tag
        let item = items[index]
        delegate?.didTapSustainableItem(item)
    }
}
