//
//  MainTVCell.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import UIKit

class MainTVCell: UITableViewCell {
    
    
    // MARK: - Properties
            
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray
        return imageView
    }()
    
    
    // MARK: - Static helpers
    
    class var cellIdentifier: String {
        return String(describing: self)
    }

    class func registerForTableView(_ tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: cellIdentifier)
    }
    
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public config
    
    func configureCell(_ title: String) {
        titleLabel.text = title
    }
    
    
    // MARK: - UI Setup
    
    private func configureUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
}
