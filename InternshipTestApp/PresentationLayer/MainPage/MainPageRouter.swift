//
//  MainPageRouter.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 28.08.2023.
//

import UIKit

protocol MainPageRouterInput {
    func showDetailScreen(with id: String)
}

final class MainPageRouter {
    weak var transitionHandler: UIViewController?
    
    private let detailsPageAssembly: DetailsPageAssemblyProtocol
    
    init(detailsPageAssembly: DetailsPageAssemblyProtocol) {
        self.detailsPageAssembly = detailsPageAssembly
    }
}

extension MainPageRouter: MainPageRouterInput {
    func showDetailScreen(with id: String) {
        guard let navigationController = transitionHandler?.navigationController else {
            return
        }
        
        let detailsScreenViewController = detailsPageAssembly.assemble(with: id)
        navigationController.pushViewController(detailsScreenViewController, animated: true)
    }
}
