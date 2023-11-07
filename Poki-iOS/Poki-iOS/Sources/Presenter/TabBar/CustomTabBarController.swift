//
//  TabBarController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit

class CustomTabBarController: UITabBarController {

    // MARK: - Life Cycle

    override func loadView() {
        super.loadView()
        self.setupTabBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.backgroundColor = .clear
        self.setupItems()
    }

    // MARK: - Helpers

    func setupTabBar() {
        self.tabBar.itemWidth = 40
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 180
    }

    private func setupItems() {
        let mainPageVC = MainPageVC()
        mainPageVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "square.on.square"), tag: 0)

        let poseSuggestionVC = PoseSuggestionVC()
        poseSuggestionVC.tabBarItem = UITabBarItem(title: "포즈 추천", image: UIImage(systemName: "figure.walk"), tag: 1)

        let myPageVC = MyPageVC()
        myPageVC.tabBarItem = UITabBarItem(title: "마이 페이지", image: UIImage(systemName: "person.fill"), tag: 2)

        tabBar.tintColor = Constants.appBlackColor
        tabBar.unselectedItemTintColor = .gray

        let controllers = [mainPageVC, poseSuggestionVC, myPageVC]
        viewControllers = controllers.map { DynamicStatusBarNavigation(rootViewController: $0) }
    }
}

// MARK: - UITabBarControllerDelegate

extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let fromView = selectedViewController?.view
        let toView = viewController.view

        if fromView != toView {
            UIView.transition(from: fromView!, to: toView!, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}

// MARK: - Status Bar Custom Setting

open class DynamicStatusBarNavigation: UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
