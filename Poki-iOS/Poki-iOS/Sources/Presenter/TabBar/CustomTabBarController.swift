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
//        self.setupHomeButton()
    }
    
    
    // MARK: - Helpers

    func setupTabBar() {
//        let path: UIBezierPath = self.createBezierPath()
//        let shape = CAShapeLayer()
//        shape.path = path.cgPath
//        shape.lineWidth = 3
//        shape.strokeColor = UIColor.white.cgColor
//        shape.fillColor = UIColor.white.cgColor
//        self.tabBar.layer.insertSublayer(shape, at: 0)
        self.tabBar.itemWidth = 40
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 180
    }
//
//    func createBezierPath() -> UIBezierPath {
//        let frameWidth = self.tabBar.bounds.width
//        let frameHeight = self.tabBar.bounds.height + 40
//        let holeWidth = 150
//        let holeHeight = 70
//        let leftXUntilHole = Int(frameWidth / 2) - Int(holeWidth / 2)
//        let path = UIBezierPath()
//        path.move(to: .zero)
//        path.addLine(to: CGPoint(x: leftXUntilHole, y: 0))
//        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth / 3), y: holeHeight / 2),
//                      controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth / 3) / 8) * 6, y: 0),
//                      controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth / 3) / 8) * 8, y: holeHeight / 2))
//        path.addCurve(to: CGPoint(x: leftXUntilHole + (2 * holeWidth) / 3, y: holeHeight / 2),
//                      controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth / 3) + (holeWidth / 3) / 3 * 2 / 5, y: (holeHeight / 2) * 6 / 4),
//                      controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth / 3) + (holeWidth / 3) / 3 * 2 + (holeWidth / 3) / 3 * 3 / 5, y: (holeHeight / 2) * 6 / 4))
//        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0),
//                      controlPoint1: CGPoint(x: leftXUntilHole + (2 * holeWidth) / 3, y: holeHeight / 2),
//                      controlPoint2: CGPoint(x: leftXUntilHole + (2 * holeWidth) / 3 + (holeWidth / 3) * 2 / 8, y: 0))
//        path.addLine(to: CGPoint(x: frameWidth, y: 0))
//        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight))
//        path.addLine(to: CGPoint(x: 0, y: frameHeight))
//        path.addLine(to: CGPoint(x: 0, y: 0))
//        path.close()
//        return path
//    }

   private func setupItems() {
       let mainPageVC = MainPageVC()
       mainPageVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "square.on.square"), tag: 0)

       let poseSuggestionVC = PoseSuggestionVC()
       poseSuggestionVC.tabBarItem = UITabBarItem(title: "포즈 추천", image: UIImage(systemName: "figure.walk"), tag: 1)

       let myPageVC = MyPageVC()
       myPageVC.tabBarItem = UITabBarItem(title: "마이 페이지", image: UIImage(systemName: "person.fill"), tag: 2)
       
       tabBar.tintColor = .black
       tabBar.unselectedItemTintColor = .gray

       let controllers = [mainPageVC, poseSuggestionVC, myPageVC]
       viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
    }

//    func setupHomeButton() {
//        let frameWidth = Int(self.tabBar.bounds.width)
//        let button = UIButton(frame: CGRect(x: frameWidth / 2 - 30, y: -20, width: 60, height: 60))
//        button.setBackgroundImage(UIImage(named: "homeButton"), for: .normal)
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOpacity = 0.1
//        button.layer.shadowOffset = CGSize(width: 4, height: 4)
//        self.tabBar.addSubview(button)
//        button.addTarget(self, action: #selector(self.homeButtonTapped(sender:)), for: .touchUpInside)
//        self.view.layoutIfNeeded()
//    }
//    
//    // MARK: - Actions
//
//    @objc func homeButtonTapped(sender: UIButton) {
//        self.selectedIndex = 0
//    }
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

