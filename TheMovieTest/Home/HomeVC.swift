//
//  HomeVC.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 08/10/22.
//

import UIKit

class HomeVC: UIPageViewController {
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(frame: .zero)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.tintColor = .red
        segmentControl.backgroundColor = .white
        segmentControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        return segmentControl
    }()
    
    private var coordinator: CoordinatorProtocol?
    private var pages: [UIViewController] = [UIViewController]()
    private var currentIndex: Int {
        guard let visibleVC = viewControllers?.first, let pageIndex = pages.firstIndex(of: visibleVC) else {
            return 0
        }
        return pageIndex
    }

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = nil
        setupView()
        moveTo(newIndex: 0)
    }

    func setupView() {
        if let navigation = navigationController {
            coordinator = Coordinator(navigation)
        }
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "menucard.fill"), for: .normal)
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        button.frame = CGRectMake(0, 0, 53, 31)
        let menuBarButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = menuBarButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        view.addSubview(segmentControl)
        let movieTypes = Constants.MovieType.allCases.map { $0.title }
        for (index, type) in movieTypes.enumerated() {
            segmentControl.insertSegment(withTitle: type, at: index, animated: false)
        }
        segmentControl.selectedSegmentIndex = 0
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentControl.heightAnchor.constraint(equalToConstant: 40),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])

        Constants.MovieType.allCases.forEach { type in
            let viewController = DynamicScreenVC(with: type, and: coordinator)
            pages.append(viewController)
        }
    }
    
    @objc
    private func segmentedValueChanged(_ sender: UISegmentedControl) {
        moveTo(newIndex: sender.selectedSegmentIndex)
    }
    
    @objc
    private func menuTapped() {
        let alert = UIAlertController(title: "What do you want to do?", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View Profile", style: .default , handler:{ [weak self] _ in
            self?.coordinator?.showUserProfile()
        }))
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive , handler:{ [weak self] _ in
            self?.coordinator?.logOut()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ _ in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func moveTo(newIndex: Int) {
       setViewControllers([pages[newIndex]], direction: ((currentIndex < newIndex) ? .forward : .reverse), animated: true)
   }
}

extension HomeVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else { return pages.last }

        guard pages.count > previousIndex else { return nil }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else { return pages.first }

        guard pages.count > nextIndex else { return nil }

        return pages[nextIndex]
    }
}

extension HomeVC: UIPageViewControllerDelegate { }
