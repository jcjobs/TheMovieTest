//
//  MovieCollectionViewCell.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    private lazy var movieImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "video.fill")
        return view
    }()
    
    private lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .large
        label.numberOfLines = 1
        label.textColor = .green
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.distribution = .fillProportionally
        stack.spacing = 0
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var movieDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium
        label.numberOfLines = 1
        label.textColor = .green
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var movieRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium
        label.numberOfLines = 1
        label.textColor = .green
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .small
        label.numberOfLines = 0
        label.textColor = .black
        //label.adjustsFontSizeToFitWidth = true
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
        movieImageView.image = nil
        movieNameLabel.text = ""
        movieDateLabel.text = ""
        movieRateLabel.text = ""
        movieDescriptionLabel.text = ""
    }
    
    private func setupView() {
        addSubview(movieImageView)
        addSubview(movieNameLabel)
        addSubview(stackView)
        addSubview(movieDateLabel)
        addSubview(movieRateLabel)
        addSubview(movieDescriptionLabel)
        stackView.addArrangedSubview(movieDateLabel)
        stackView.addArrangedSubview(movieRateLabel)
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            movieImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            movieImageView.heightAnchor.constraint(equalToConstant: 200),
            
            movieNameLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            movieNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            movieNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            movieNameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            stackView.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalToConstant: 20),
  
            movieDescriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            movieDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    func configure(with movie: Movie) {
        movieNameLabel.text = movie.title
        let releaseDate = Date(dateString: movie.releaseDate ?? "")
        movieDateLabel.text = releaseDate.getFormatedDate()
        movieRateLabel.text = "*\(movie.voteAverage)"
        movieDescriptionLabel.text = movie.sinopsis
        
        if let imagePath = movie.image {
            let defaultImage = UIImage(systemName: "video.fill")
            movieImageView.setImage(with: imagePath, and: defaultImage)
        }
    }
    
    override func layoutSubviews() {
        self.customStyle()
    }
}
