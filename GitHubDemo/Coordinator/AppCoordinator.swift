//
//  File.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import UIKit


protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

/// 用來處理導航
class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        naviToList()
    }
    
    func naviToProfile() {
        let profileViewController = ProfileViewController()
        navigationController.present(profileViewController, animated: true)
    }
    
    // private func
    private func naviToList() {
        let listViewController = ListViewController()
        listViewController.presentPofileView = naviToProfile
        navigationController.pushViewController(listViewController, animated: true)
    }
}
