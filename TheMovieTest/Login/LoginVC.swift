//
//  LoginVC.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import UIKit
import SwiftUI
import Combine

class LoginVC: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "background-image")
        return view
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        view.color = .white
        return view
    }()
    
    private lazy var userNameTextfield: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .large
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.placeholder = "user"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .large
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.backgroundColor = .green
        return button
    }()
    
    private var viewModel: LoginProtocol
    private var coordinator: CoordinatorProtocol?
    
    private var cancellables: AnyCancellable?
    private var bag = Set<AnyCancellable>()
    
    init() {
        viewModel = LoginVM()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("LoginVC :: init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        subscribe()
    }

    func setupView() {
        if let navigation = navigationController {
            coordinator = Coordinator(navigation)
        }
        
        view.addSubview(backgroundImageView)
        view.addSubview(userNameTextfield)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(loadingView)
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        userNameTextfield.addTarget(self, action: #selector(dismissKeyboard), for: .primaryActionTriggered)
        passwordTextField.addTarget(self, action: #selector(loginAction), for: .primaryActionTriggered)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            userNameTextfield.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            userNameTextfield.heightAnchor.constraint(equalToConstant: 50),
            userNameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            userNameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func subscribe() {
        cancellables = viewModel.isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                self?.loginButton.isEnabled = !isLoading
                
                if isLoading {
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.stopAnimating()
                }
            }
        
         viewModel.loginSucced
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.coordinator?.showHomeView()
        }.store(in: &bag)
        
        viewModel.processError
            .receive(on: RunLoop.main)
            .sink { [weak self] processError in
                self?.coordinator?.presentErrror(with: processError)
        }.store(in: &bag)
    }
    
    @objc
    private func loginAction() {
        let usermane = "jcjobs"//userNameTextfield.text ?? ""
        let password = "12345jc"//passwordTextField.text ?? ""
        viewModel.makeLogin(with: usermane, and: password)
        loadingView.startAnimating()
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

//You can use this class in UIKit
class LoginSUIViewController: UIHostingController<LoginVCSUI> {
    let coordinator: CoordinatorProtocol
    
    required init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(rootView: LoginVCSUI(coordinator: coordinator))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}


