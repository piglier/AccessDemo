//
//  File.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import UIKit
import ComposableArchitecture

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
    
    
    // private func
    
    private func present(store: StoreOf<ProfileReducer>) {
        let profileVC = ProfileViewController()
        profileVC.store = store
        navigationController.present(profileVC, animated: true)
    }
    
    private func naviToList() {
        let listViewController = ListViewController()
        listViewController.presentPofileView = {[weak self] store in
            self?.present(store: store)
        }
        navigationController.pushViewController(listViewController, animated: true)
    }
}
