import Foundation
import SwiftUI

class TabBarCoordinator<Router: NavigationRouter>: Coordinator<TabBarRouter> {
    var tabBarController: UITabBarController
    var authManager: AuthManager
    var mainCoordinator: MainCoordinator<MainCoordinatorRouter>?
    
    init(
        navigationController: UINavigationController = .init(),
        mainCoordinator: Coordinator<MainCoordinatorRouter>,
        authManager: AuthManager,
        startingRoute: TabBarRouter? = nil) {
            self.mainCoordinator = mainCoordinator as? MainCoordinator<MainCoordinatorRouter>
            self.authManager = authManager
            self.tabBarController = .init()
            super.init(navigationController: navigationController, startingRoute: .home)
    }
    
    public override func start() {
        let tabRoutes: [TabBarRouter] = [.home, .settings]
        let controllers: [UINavigationController] = tabRoutes.map { getTabController($0) }

        prepareTabBarController(withTabControllers: controllers)
    }

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarRouter.home.tabIndex
        tabBarController.edgesForExtendedLayout = UIRectEdge(rawValue: 0)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance

        tabBarController.tabBar.tintColor = .black
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    private func getTabController(_ tab: TabBarRouter) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)

        navController.tabBarItem = UITabBarItem.init(title: tab.title,
                                                     image: UIImage(systemName: tab.imageName),
                                                     tag: tab.tabIndex)
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)

        switch tab {
        case .home:
            let coordinator = HomeFlowCoordinator<HomeFlowRouter>(navigationController: navController, startingRoute: .home, tabbarCoordinator: self)
            coordinator.start()
        case .settings:
            let coordinator = SettingsFlowCoordinator<SettingsFlowRouter>(navigationController: navController, tabbarCoordinator: self, authManager: authManager)
            coordinator.start()
        }
        return navController
    }

    func goToTab(index: Int) {
        tabBarController.selectedIndex = index
    }
    
    func goToAuthenticationFlow() {
        mainCoordinator?.showLoginFlow()
    }
}