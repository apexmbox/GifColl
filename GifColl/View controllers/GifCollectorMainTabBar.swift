//
//  GifCollectorMainTabBar.swift
//  GifColl
//
//  Created by Apex on 28.08.2021.
//

import UIKit


class GifCollectorMainTabBar: UITabBarController {
   
    var collector = GifCollectorModel()
    var firstVC: GifCollectorViewController?
    var secondVC: GifCollectorViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        //UITabBar.appearance().barTintColor = .systemBackground
        
        tabBar.tintColor = .label
        
        firstVC = GifCollectorViewController(withDataModel: collector)
        secondVC = GifCollectorViewController(withDataModel: collector)
        secondVC?.delegate = self
        
        setupVCs()
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage, enableRefreshButton: Bool = false) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        if enableRefreshButton {
            rootViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTap))
        }
        return navController
    }
    
    @objc func refreshTap() {
        if collector.modelState == .browse {
            collector.refreshRandomGifs()
            self.firstVC?.collectionView.reloadData()
        }
    }
    
    func setupVCs() {
        guard let firstVC = firstVC else { return }
        guard let secondVC = secondVC else { return }
        viewControllers = [
            createNavController(for: firstVC, title: NSLocalizedString("Browse", comment: ""), image: UIImage(systemName: "square.grid.2x2")!, enableRefreshButton: true),
            createNavController(for: secondVC, title: NSLocalizedString("Saved", comment: ""), image: UIImage(systemName: "heart")!)]
    }
}

extension GifCollectorMainTabBar: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let items = tabBar.items, items.count == 2 {
            if tabBar.selectedItem == items[0] {
                collector.modelState = .browse
                firstVC?.hideEmptyScreenElements()
                self.firstVC?.collectionView.reloadData()
            } else if tabBar.selectedItem == items[1] {
                collector.modelState = .saved
                if collector.savedGifUrls.isEmpty {
                    secondVC?.showEmptyScreenElements()
                } else {
                    secondVC?.hideEmptyScreenElements()
                    self.secondVC?.collectionView.reloadData()
                }
            } else {
                print("it's IDC tab")
            }
        }
    }
}

extension GifCollectorMainTabBar: GifCollectorViewControllerDelegate {
    func findButtonTapped() {
        self.selectedIndex = 0
        collector.modelState = .browse
        self.firstVC?.collectionView.reloadData()
    }
}
