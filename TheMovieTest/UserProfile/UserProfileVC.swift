//
//  UserProfileVC.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 08/10/22.
//

import UIKit
import SwiftUI
import Combine

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
    private var bag = Set<AnyCancellable>()
    
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
        viewModel.isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.stopAnimating()
                }
            }
            .store(in: &bag)

        viewModel.didFetchData
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                if let currentUser = Session.shared.user {
                    let defaultImage = UIImage(systemName: "person")
                    self?.userImageView.setImage(with: currentUser.avatar.tmdb.avatarPath, and: defaultImage)
                    self?.userNameLabel.text = currentUser.username
                }
        }.store(in: &bag)

        viewModel.processError
            .receive(on: RunLoop.main)
            .sink { [weak self] processError in
                let alert = UIAlertController(title: "Error", message: processError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
        }.store(in: &bag)
    }
}


//You can use this class in UIKit
class UserProfileSUIViewController: UIHostingController<UserProfileVCSUI> {
    let viewModel: UserProfileVMProtocol
    
    required init(with viewModel: UserProfileVMProtocol) {
        self.viewModel = viewModel
        super.init(rootView: UserProfileVCSUI(with: viewModel))
    }
    
    //Use from Storyboard init
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
