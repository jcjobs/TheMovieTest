//
//  CompanyCollectionViewCell.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 10/10/22.
//

import UIKit

class CompanyCollectionViewCell: UICollectionViewCell {
    private lazy var companyImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var companyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .large
        label.numberOfLines = 1
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        companyImageView.image = UIImage(systemName: "building.2")
        companyNameLabel.text = ""
    }
    
    private func setupView() {
        addSubview(companyImageView)
        addSubview(companyNameLabel)
        
        NSLayoutConstraint.activate([
            companyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            companyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            companyImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            companyImageView.bottomAnchor.constraint(equalTo: companyNameLabel.topAnchor),
            
            companyNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            companyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            companyNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            companyNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with company: Company) {
        companyNameLabel.text = company.name
        
        if let imagePath = company.logoPath {
            let defaultImage = UIImage(systemName: "building.2")
            companyImageView.setImage(with: imagePath, and: defaultImage, and: .green)
        }
    }
}
