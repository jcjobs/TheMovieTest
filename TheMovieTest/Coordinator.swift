//
//  Coordinator.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import UIKit
import CoreComponents

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }
    
    func showHomeView()
    func showMovieDetail(with movie: Movie)
    func showUserProfile()
    func presentErrror(with error: CustomError)
    func logOut()
}

final class Coordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init (_ navigationController: UINavigationController = .init()) {
        self.navigationController = navigationController
    }
    
    func start() {
        //let viewController = LoginVC() //UIKit
        let viewController = LoginSUIViewController(coordinator: self) //SwiftUI
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showHomeView() {
        let viewController = HomeVC() //UIKit
        //let viewController = HomeVCRepresentable() //SwiftUI
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMovieDetail(with movie: Movie) {
        navigationController.navigationBar.topItem?.title = ""
        let viewController = MovieDetailVC(with: movie) //UIKit
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentErrror(with error: CustomError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        navigationController.viewControllers.last?.present(alert, animated: true, completion: nil)
    }
    
    func showUserProfile() {
        navigationController.navigationBar.topItem?.title = ""
        //let viewController = UserProfileVC() //UIKit
        let viewModel: UserProfileVMProtocol = UserProfileVM()
        let viewController = UserProfileSUIViewController(with: viewModel) //SwiftUI
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func logOut() {
        CoreSession.shared.clearSession()
        Session.shared.clearSession()
        navigationController.popToRootViewController(animated: true)
    }
}
