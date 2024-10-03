//
//  File.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/8/17.
//

import UIKit
import ComposableArchitecture

class AppCoordinator: PresentationCoordinator {
    var childCoordinators: [Coordinator] = []
    var rootViewController = ListViewController()
    
    init(window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func start() {
        route()
    }
    
    private func presentProfleWithStore(_ store: StoreOf<ProfileReducer>) {
        let profileCoordinaotor = ProfileCoordinator(store)
        presentationCoordinator(coordinator: profileCoordinaotor, animated: true)
    }
    
    private func route() {
        rootViewController.presentPofileView = { [weak self] store in
            self?.presentProfleWithStore(store)
        }
    }
    
}

class ProfileCoordinator: PresentationCoordinator {
    var childCoordinators: [Coordinator] = []
    var rootViewController: ProfileViewController
    
    init(_ store: StoreOf<ProfileReducer>) {
        rootViewController = ProfileViewController(store: store)
    }
    
    func start() {}
}
