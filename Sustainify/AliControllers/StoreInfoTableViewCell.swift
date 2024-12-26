//
//  StoreInfoTableViewCell.swift
//  Sustainify
//

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
    
    let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let storeTimingsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
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
        contentView.addSubview(storeImageView)
        contentView.addSubview(storeTitleLabel)
        contentView.addSubview(storeTimingsLabel)
        contentView.addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            // Image across the top
            storeImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),
            storeImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            storeImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            storeImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Separator line below
            separatorLine.topAnchor.constraint(
                equalTo: storeImageView.bottomAnchor,
                constant: 10
            ),
            separatorLine.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),
            separatorLine.widthAnchor.constraint(equalToConstant: 1),
            separatorLine.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            
            // Title left of line
            storeTitleLabel.topAnchor.constraint(
                equalTo: storeImageView.bottomAnchor,
                constant: 10
            ),
            storeTitleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            storeTitleLabel.trailingAnchor.constraint(
                equalTo: separatorLine.leadingAnchor,
                constant: -10
            ),
            storeTitleLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -10
            ),
            
            // Timings right of line
            storeTimingsLabel.topAnchor.constraint(
                equalTo: storeImageView.bottomAnchor,
                constant: 10
            ),
            storeTimingsLabel.leadingAnchor.constraint(
                equalTo: separatorLine.trailingAnchor,
                constant: 10
            ),
            storeTimingsLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            storeTimingsLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -10
            )
        ])
    }
    
    func configure(with store: Store) {
        storeImageView.image = UIImage(named: store.imageName)
        storeTitleLabel.text = store.name
        
        storeTimingsLabel.text = """
        Opens: \(store.openingTime)
        Closes: \(store.closingTime)
        """
    }
}
