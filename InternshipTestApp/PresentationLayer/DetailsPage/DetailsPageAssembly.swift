//
//  DetailsPageAssembly.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 28.08.2023.
//

import UIKit

protocol DetailsPageAssemblyProtocol {
    func assemble(with id: String) -> UIViewController
}

final class DetailsPageAssembly {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension DetailsPageAssembly: DetailsPageAssemblyProtocol {
    func assemble(with id: String) -> UIViewController {
        
        let presenter = DetailsPagePresenter(
            itemId: id,
            networkManager: networkManager
        )
        
        let viewController = DetailsPageViewController(
            output: presenter
        )
        
        presenter.view = viewController
        
        return viewController
    }
}
