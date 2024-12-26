import UIKit

class BestSellingItemsTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Best Selling Items"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    }()
    
    // Example image
    private let imageViewPlaceholder: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PlaceholderImage") // Replace with real image asset
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(imageViewPlaceholder)
        
        NSLayoutConstraint.activate([
            // Title label at top
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // ScrollView below label
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            scrollView.heightAnchor.constraint(equalToConstant: 150),
            
            // Example placeholder image
            imageViewPlaceholder.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageViewPlaceholder.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageViewPlaceholder.widthAnchor.constraint(equalToConstant: 200),
            imageViewPlaceholder.heightAnchor.constraint(equalToConstant: 140),
            imageViewPlaceholder.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func configure() {
        // In the future, you can dynamically add multiple product images to the scrollView
        // For now, it’s just a single placeholder
    }
}
