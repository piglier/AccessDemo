//
//  Coordinator.swift
//  GitHubDemo
//
//  Created by 朱彥睿 on 2024/9/29.
//

import UIKit

/// handle the child coordinators
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { set get }
    func start()
}

// handle present & dismiss
extension Coordinator {
    func addCoordinator(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeCoordinator(coordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === coordinator }) else { return }
        childCoordinators.remove(at: index)
    }
}

/// underlying present is for assoicatedType complier error

protocol _PresentationCoordinator: Coordinator {
    var _rootViewController: UIViewController { get }
}

/// baseType handle rootViewController
protocol PresentationCoordinator: _PresentationCoordinator {
    associatedtype ViewController: UIViewController
    var rootViewController: ViewController { get }
}

/// base default presentation

extension PresentationCoordinator {
    var _rootViewController: UIViewController { return rootViewController }
}

/// handle presentation & dismiss
extension PresentationCoordinator {
    func presentationCoordinator(coordinator: _PresentationCoordinator, animated: Bool) {
        rootViewController.present(coordinator._rootViewController, animated: animated)
        coordinator.start()
        addCoordinator(coordinator: coordinator)
    }
    
    func dismissCoordinator(coordinator: _PresentationCoordinator, animated: Bool, onDismissCompletion: (() -> Void)?) {
        coordinator._rootViewController.dismiss(animated: animated, completion: onDismissCompletion)
        removeCoordinator(coordinator: coordinator)
    }
}

