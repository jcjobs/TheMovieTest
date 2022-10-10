//
//  Coordinator.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 07/10/22.
//

import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController? { get set }
    
    func showHomeView()
    func presentMovieDetail(with movie: Movie)
    func presentErrror(with error: CustomError)
    func showUserProfile()
    func logOut()
}

final class Coordinator: CoordinatorProtocol {
    var navigationController: UINavigationController?
    
    init (_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showHomeView() {
        let viewController = HomeVC()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentMovieDetail(with movie: Movie) {
        navigationController?.navigationBar.topItem?.title = ""
        let viewController = MovieDetailVC(with: movie)
        //navigationController?.viewControllers.last?.present(viewController, animated: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentErrror(with error: CustomError) {
        let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        navigationController?.viewControllers.last?.present(alert, animated: true, completion: nil)
    }
    
    func showUserProfile() {
        navigationController?.navigationBar.topItem?.title = ""
        let viewController = UserProfileVC()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func logOut() {
        Session.shared.user = nil
        navigationController?.popToRootViewController(animated: true)
    }
}
