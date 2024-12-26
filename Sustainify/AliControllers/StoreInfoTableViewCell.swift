import UIKit

class StoreInfoTableViewCell: UITableViewCell {
    
    let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let storeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let storeTimingsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(storeImageView)
        contentView.addSubview(storeDescriptionLabel)
        contentView.addSubview(storeTimingsLabel)
        
        NSLayoutConstraint.activate([
            storeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            storeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            storeImageView.heightAnchor.constraint(equalToConstant: 200),
            
            storeDescriptionLabel.topAnchor.constraint(equalTo: storeImageView.bottomAnchor, constant: 10),
            storeDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storeDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            storeTimingsLabel.topAnchor.constraint(equalTo: storeDescriptionLabel.bottomAnchor, constant: 10),
            storeTimingsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storeTimingsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            storeTimingsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with store: Store) {
        storeImageView.image = UIImage(named: store.imageName)
        storeDescriptionLabel.text = store.detail
        storeTimingsLabel.text = "Opens: \(store.openingTime)\nCloses: \(store.closingTime)"
    }
}
