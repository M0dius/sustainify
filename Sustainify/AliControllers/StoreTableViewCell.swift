import UIKit

class StoreTableViewCell: UITableViewCell {
    
    let storeImageView = UIImageView()
    let nameLabel = UILabel()
    let detailLabel = UILabel()
    let timingsBackgroundView = UIView()
    let openingTimeLabel = UILabel()
    let closingTimeLabel = UILabel()
    let separatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        addSubview(storeImageView)
        addSubview(nameLabel)
        addSubview(detailLabel)
        addSubview(timingsBackgroundView)
        timingsBackgroundView.addSubview(openingTimeLabel)
        timingsBackgroundView.addSubview(separatorView)
        timingsBackgroundView.addSubview(closingTimeLabel)
        
        // Configure the image view
        storeImageView.translatesAutoresizingMaskIntoConstraints = false
        storeImageView.layer.cornerRadius = 10
        storeImageView.clipsToBounds = true
        storeImageView.contentMode = .scaleAspectFill
        
        // Configure the labels
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 26)
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = UIFont.systemFont(ofSize: 16)
        detailLabel.textColor = .gray
        
        // Configure the timings labels
        openingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        openingTimeLabel.font = UIFont.boldSystemFont(ofSize: 10)  
        openingTimeLabel.textColor = .white
        openingTimeLabel.textAlignment = .center
        openingTimeLabel.numberOfLines = 2
        
        closingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        closingTimeLabel.font = UIFont.boldSystemFont(ofSize: 10)  // Adjusted font size and made bold
        closingTimeLabel.textColor = .white
        closingTimeLabel.textAlignment = .center
        closingTimeLabel.numberOfLines = 2  // Ensure multiline consistency with openingTimeLabel
        
        // Configure the separator view
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        // Configure the timings background view
        timingsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        timingsBackgroundView.backgroundColor = UIColor(red: 43/255.0, green: 158/255.0, blue: 13/255.0, alpha: 1.0)
        timingsBackgroundView.layer.cornerRadius = 10
        timingsBackgroundView.layer.masksToBounds = true
        
        // Set up constraints
        NSLayoutConstraint.activate([
            storeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            storeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            storeImageView.widthAnchor.constraint(equalToConstant: 80),
            storeImageView.heightAnchor.constraint(equalToConstant: 80),
            storeImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10), // Changed to avoid conflict
            
            nameLabel.leadingAnchor.constraint(equalTo: storeImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: timingsBackgroundView.leadingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: storeImageView.topAnchor),
            
            detailLabel.leadingAnchor.constraint(equalTo: storeImageView.trailingAnchor, constant: 10),
            detailLabel.trailingAnchor.constraint(equalTo: timingsBackgroundView.leadingAnchor, constant: -10),
            detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -4), // Nudged closer to title
            
            timingsBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            timingsBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            timingsBackgroundView.widthAnchor.constraint(equalToConstant: 80),
            timingsBackgroundView.heightAnchor.constraint(lessThanOrEqualTo: storeImageView.heightAnchor), // Changed to avoid conflict
            
            openingTimeLabel.topAnchor.constraint(equalTo: timingsBackgroundView.topAnchor, constant: 10),
            openingTimeLabel.leadingAnchor.constraint(equalTo: timingsBackgroundView.leadingAnchor),
            openingTimeLabel.trailingAnchor.constraint(equalTo: timingsBackgroundView.trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: openingTimeLabel.bottomAnchor, constant: 5),
            separatorView.leadingAnchor.constraint(equalTo: timingsBackgroundView.leadingAnchor, constant: 5),
            separatorView.trailingAnchor.constraint(equalTo: timingsBackgroundView.trailingAnchor, constant: -5),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            closingTimeLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 5),
            closingTimeLabel.leadingAnchor.constraint(equalTo: timingsBackgroundView.leadingAnchor),
            closingTimeLabel.trailingAnchor.constraint(equalTo: timingsBackgroundView.trailingAnchor),
            closingTimeLabel.bottomAnchor.constraint(lessThanOrEqualTo: timingsBackgroundView.bottomAnchor, constant: -10) // Adjusted to avoid conflicts
        ])
    }

    
    func configure(with store: Store) {
        storeImageView.image = UIImage(named: store.imageName)
        nameLabel.text = store.name
        detailLabel.text = store.detail
        openingTimeLabel.text = "Opens at\n\(store.openingTime)"
        closingTimeLabel.text = "Closes at\n\(store.closingTime)"
    }
}
