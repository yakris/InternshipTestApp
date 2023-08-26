//
//  DetailsPageViewController.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 28.08.2023.
//

import UIKit

protocol DetailsPageViewOutput {
    func viewDidLoad()
}

protocol DetailsPageViewInput: AnyObject {
    func setContentState(_ state: DetailsPageViewState)
}

enum DetailsPageViewState {
    case loading
    case content(_ models: DetailsPageViewModel)
    case empty(_ model: EmptyViewModel)
}

final class DetailsPageViewController: UIViewController {
    private enum Constants {
        static let animationLoadingName = "data-loader"
    }
    
    private let output: DetailsPageViewOutput
    
    private let contentScrolView = UIScrollView()
    private let detailsView = DetailsPageView()
    private let loadingView = LoadingView()
    private let emptyView = EmptyView()

    init(output: DetailsPageViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        
        configure()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Private

private extension DetailsPageViewController {
    func configure() {
        view.backgroundColor = .white
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.largeTitleDisplayMode = .never
        
        contentScrolView.showsVerticalScrollIndicator = false
    }
    
    func setupLayout() {
        [contentScrolView, detailsView, loadingView, emptyView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [contentScrolView, loadingView, emptyView].forEach {
            view.addSubview($0)
        }
        
        contentScrolView.addSubview(detailsView)
        
        NSLayoutConstraint.activate([
            contentScrolView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrolView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentScrolView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentScrolView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            detailsView.topAnchor.constraint(equalTo: contentScrolView.topAnchor),
            detailsView.bottomAnchor.constraint(equalTo: contentScrolView.bottomAnchor),
            detailsView.widthAnchor.constraint(equalTo: view.widthAnchor),
            detailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}

// MARK: - DetailsPageViewInput

extension DetailsPageViewController: DetailsPageViewInput {
    func setContentState(_ state: DetailsPageViewState) {
        contentScrolView.isHidden = true
        emptyView.isHidden = true
        loadingView.isHidden = true

        loadingView.stop()

        switch state {
        case .loading:
            loadingView.play(animationName: Constants.animationLoadingName)
            loadingView.isHidden = false
        case let .content(model):
            detailsView.configure(with: model)
            contentScrolView.isHidden = false
        case let .empty(model):
            emptyView.configure(with: model)
            emptyView.isHidden = false
        }
    }
}
