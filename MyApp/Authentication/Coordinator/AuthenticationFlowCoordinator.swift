import UIKit

class AuthenticationFlowCoordinator<Router: NavigationRouter>: Coordinator<AuthenticationFlowRouter> {
    private let mainCoordinator: MainCoordinator<MainCoordinatorRouter>?
    
    init(navigationController: UINavigationController = .init(), mainCoordinator: Coordinator<MainCoordinatorRouter>, authManager: AuthManager, startingRoute: AuthenticationFlowRouter? = nil) {
        self.mainCoordinator = mainCoordinator as? MainCoordinator<MainCoordinatorRouter>
        super.init(navigationController: navigationController, startingRoute: .authenticationOptionsView(authManager: authManager))
    }
    
    // Override the base Coordinator's show() function because the environmentObject needs to be of type AuthenticationFlowCoordinator and not BaseCoordinator
    public override func show(_ route: AuthenticationFlowRouter, hideTabBar: Bool = false, hideNavBar: Bool = false, animated: Bool = true, environmentObjects: [any ObservableObject] = []) {
        var environmentObjects: [any ObservableObject] = environmentObjects
        environmentObjects.append(self)
        super.show(route, hideTabBar: hideTabBar, hideNavBar: hideNavBar, animated: animated, environmentObjects: environmentObjects)
    }

    func userSignedIn() {
        navigationController.setViewControllers([], animated: false)
        mainCoordinator?.showMainAppFlow()
    }
}