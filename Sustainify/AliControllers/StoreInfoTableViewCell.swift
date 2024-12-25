import UIKit

class StoreInfoTableViewCell: UITableViewCell {

    // UI Components
    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let storeDetailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let openingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let closingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        // Add subviews
        contentView.addSubview(storeImageView)
        contentView.addSubview(storeDetailsLabel)
        contentView.addSubview(openingTimeLabel)
        contentView.addSubview(closingTimeLabel)

        // Apply constraints
        NSLayoutConstraint.activate([
            // Store Image
            storeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            storeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            storeImageView.heightAnchor.constraint(equalToConstant: 200),

            // Store Details
            storeDetailsLabel.topAnchor.constraint(equalTo: storeImageView.bottomAnchor, constant: 8),
            storeDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storeDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Opening Time
            openingTimeLabel.topAnchor.constraint(equalTo: storeDetailsLabel.bottomAnchor, constant: 8),
            openingTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // Closing Time
            closingTimeLabel.topAnchor.constraint(equalTo: openingTimeLabel.bottomAnchor, constant: 4),
            closingTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            closingTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    // Configure the cell
    func configure(with store: Store) {
        storeImageView.image = UIImage(named: store.imageName)
        storeDetailsLabel.text = store.detail
        openingTimeLabel.text = "Opens: \(store.openingTime)"
        closingTimeLabel.text = "Closes: \(store.closingTime)"
    }
}
