//
//  DynamicScreen.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import UIKit

class DynamicScreenVC: UIViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        view.color = .white
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var viewModel: DyamicScreenProtocol
    private var moviesData: [Movie]?
    private var coordinator: CoordinatorProtocol?
    private var initialLoadComplete: Bool = false

    init(with movieType: Constants.MovieType, and coordinator: CoordinatorProtocol?) {
        viewModel = DyamicScreenVM(with: movieType)
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("DynamicScreenVC :: init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        subscribe()
        viewModel.fetchMovies()
    }
    
    func setupView() {
        view.backgroundColor = .black
        view.addSubview(loadingView)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCells([MovieCollectionViewCell.self])
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
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
    
    private func handleFetchedData() -> (([Movie]?) -> Void) {
        return { [weak self] dataResult in
            if self?.initialLoadComplete == false {
                self?.moviesData = dataResult
            } else if let dataResulttt = dataResult {
                self?.moviesData?.append(contentsOf: dataResulttt)
            }
            self?.initialLoadComplete = true
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func handleError() -> ((CustomError) -> Void) {
        return { [weak self] processError in
            DispatchQueue.main.async {
                self?.coordinator?.presentErrror(with: processError)
            }
        }
    }
}

extension DynamicScreenVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedMovie = moviesData?[safe: indexPath.row] else { return }
        coordinator?.presentMovieDetail(with: selectedMovie)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let moviesCount = moviesData?.count, indexPath.row >= moviesCount - 2 else { return }
        viewModel.fetchMoviewPagination()
    }
}

extension DynamicScreenVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let moviesData = moviesData, let movie = moviesData[safe: indexPath.row]  else {
            return UICollectionViewCell()
        }
        
        let cell: MovieCollectionViewCell = collectionView.dequeReusableCell(for: indexPath)
        cell.configure(with: movie)
        return cell
    }
}

extension DynamicScreenVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30)/2
        return CGSize(width: width, height: 350)
    }
}
