//
//  MainPageAssembly.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 27.08.2023.
//

import UIKit

protocol MainPageAssemblyProtocol {
    func assemble() -> UIViewController
}

final class MainPageAssembly: MainPageAssemblyProtocol {
    var networkManager: NetworkManagerProtocol
    var detailsPageAssembly: DetailsPageAssemblyProtocol
    
    init(
        networkManager: NetworkManagerProtocol,
        detailsPageAssembly: DetailsPageAssemblyProtocol
    ) {
        self.networkManager = networkManager
        self.detailsPageAssembly = detailsPageAssembly
    }
    
    func assemble() -> UIViewController {
        let router = MainPageRouter(
            detailsPageAssembly: detailsPageAssembly
        )
        
        let presenter = MainPagePresenter(
            router: router,
            networkManager: networkManager
        )
        
        let viewController = MainPageViewController(
            output: presenter
        )
        
        presenter.view = viewController
        router.transitionHandler = viewController
        
        return viewController
    }
}
