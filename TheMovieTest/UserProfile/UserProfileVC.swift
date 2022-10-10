//
//  UserProfileVC.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 08/10/22.
//

import UIKit

class UserProfileVC: UIViewController {
    private lazy var userImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        view.color = .white
        return view
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .large
        label.numberOfLines = 1
        label.textColor = .green
        label.textAlignment = .center
        return label
    }()
    
    private var viewModel: UserProfileVMProtocol = UserProfileVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        subscribe()
        viewModel.fetchProfileData()
    }

    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(userImageView)
        view.addSubview(loadingView)
        view.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            userImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            userImageView.heightAnchor.constraint(equalToConstant: 200),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20)
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
    
    private func handleFetchedData() -> (() -> Void) {
        return { [weak self] in
            DispatchQueue.main.async {
                if let currentUser = Session.shared.user {
                    let defaultImage = UIImage(systemName: "person")
                    self?.userImageView.setImage(with: currentUser.avatar.tmdb.avatarPath, and: defaultImage)
                    self?.userNameLabel.text = currentUser.username
                }
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
}
