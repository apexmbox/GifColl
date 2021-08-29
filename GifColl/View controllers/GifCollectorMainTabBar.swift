//
//  GifCollectorMainTabBar.swift
//  GifColl
//
//  Created by Apex on 28.08.2021.
//

import UIKit

class GifCollectorMainTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        
        tabBar.tintColor = .label
        setupVCs()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTap))
        
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
    
    @objc func refreshTap() {
        
    }

    func setupVCs() {
        viewControllers = [
            createNavController(for: GifCollectorViewController(), title: NSLocalizedString("Browse", comment: ""), image: UIImage(systemName: "square.grid.2x2")!),
            createNavController(for: GifCollectorViewController(), title: NSLocalizedString("Saved", comment: ""), image: UIImage(systemName: "heart")!)
        ]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension GifCollectorMainTabBar: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let items = tabBar.items, items.count == 2 {
            if tabBar.selectedItem == items[0] {
                print("it's browse tab")
            } else if tabBar.selectedItem == items[1] {
                print("it's saved tab")
            } else {
                print("it's IDC tab")
            }
        }
    }
}
