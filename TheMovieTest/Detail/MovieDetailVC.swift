//
//  MovieDetailVC.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 08/10/22.
//

import UIKit

class MovieDetailVC: UIViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        view.color = .white
        return view
    }()
    
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
        label.textAlignment = .center
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
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var movieRate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium
        label.numberOfLines = 1
        label.textColor = .green
        label.textAlignment = .right
        return label
    }()
    
    private lazy var movieGenres: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    private lazy var movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var movieCompanies: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium
        label.numberOfLines = 1
        label.textColor = .white
        label.text = "Companies:"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var viewModel: MovieDetailVMProtocol
    private var currentMovie: Movie
    
    init(with movie: Movie) {
        currentMovie = movie
        viewModel = MovieDetailVM()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("LoginVC :: init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        subscribe()
        viewModel.getDetail(with: currentMovie.movieID)
    }
    
    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(loadingView)
        view.addSubview(movieImageView)
        view.addSubview(movieNameLabel)
        view.addSubview(stackView)
        view.addSubview(movieDateLabel)
        view.addSubview(movieRate)
        view.addSubview(movieGenres)
        view.addSubview(movieDescriptionLabel)
        view.addSubview(movieCompanies)
        view.addSubview(collectionView)
        stackView.addArrangedSubview(movieDateLabel)
        stackView.addArrangedSubview(movieRate)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCells([CompanyCollectionViewCell.self])
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            movieImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            movieImageView.heightAnchor.constraint(equalToConstant: 200),
            
            movieNameLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            movieNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            movieNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            movieNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            stackView.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalToConstant: 25),
            
            movieGenres.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            movieGenres.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            movieGenres.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            movieGenres.heightAnchor.constraint(equalToConstant: 20),
            
            movieDescriptionLabel.topAnchor.constraint(equalTo: movieGenres.bottomAnchor, constant: 8),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            movieDescriptionLabel.bottomAnchor.constraint(equalTo: movieCompanies.topAnchor, constant: -8),
            
            movieCompanies.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -8),
            movieCompanies.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            movieCompanies.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            movieCompanies.heightAnchor.constraint(equalToConstant: 20),
            
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
    }
    
    private func subscribe() {
        viewModel.isLoading = handleisLoading()
        viewModel.didFetchData = handleFetchedData()
        viewModel.processError = handleError()
    }
    
    private func handleisLoading() -> ((Bool) -> Void) {
        return { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.stopAnimating()
                }
            }
        }
    }
    
    private func handleFetchedData() -> ((Movie) -> Void) {
        return { [weak self] dataResult in
            self?.currentMovie = dataResult

            DispatchQueue.main.async {
                self?.showMovieDetail()
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func handleError() -> ((CustomError) -> Void) {
        return { [weak self] processError in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: processError.message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func showMovieDetail() {
        movieNameLabel.text = currentMovie.title
        let releaseDate = Date(dateString: currentMovie.releaseDate ?? "")
        movieDateLabel.text = "Release date: \(releaseDate.getFormatedDate())"
        movieRate.text = "*\( currentMovie.voteAverage)"
        if let genres = currentMovie.genres?.compactMap({$0.name}) {
            movieGenres.text = "Genres: " + genres.joined(separator: ", ")
        }
        movieDescriptionLabel.text =    """
                                        Sinopsis:
                                        \n\(currentMovie.sinopsis)
                                        """
        movieDescriptionLabel.sizeToFit()
        
        if let imagePath = currentMovie.image {
            let defaultImage = UIImage(systemName: "video.fill")
            movieImageView.setImage(with: imagePath, and: defaultImage)
        }

    }
}

extension MovieDetailVC: UICollectionViewDelegate { }

extension MovieDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentMovie.productionCompanies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let companies = currentMovie.productionCompanies, let company = companies[safe: indexPath.row]  else {
            return UICollectionViewCell()
        }
        
        let cell: CompanyCollectionViewCell = collectionView.dequeReusableCell(for: indexPath)
        cell.configure(with: company)
        return cell
    }
}

extension MovieDetailVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30)/2
        return CGSize(width: width, height: 150)
    }
     
}

