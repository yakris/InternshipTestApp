//
//  ApplicationAssembly.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 31.08.2023.
//

import UIKit

final class ApplicationAssembly {
    weak var window: UIWindow?
    
    lazy var networkManager = NetworkManager()
    
    lazy var detailsPageAssembly = DetailsPageAssembly(
        networkManager: networkManager
    )
    
    lazy var mainPageAssembly = MainPageAssembly(
        networkManager: networkManager,
        detailsPageAssembly: detailsPageAssembly
    )
    
    func start() {
        let mainViewController = mainPageAssembly.assemble()
        let navigationVontroller = UINavigationController(rootViewController: mainViewController)
        
        window?.rootViewController = navigationVontroller
    }
}
