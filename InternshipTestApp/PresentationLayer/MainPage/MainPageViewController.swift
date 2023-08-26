//
//  MainPageViewController.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 26.08.2023.
//

import UIKit

protocol MainPageViewOutput {
    func viewDidLoad()
    func didTapItem(with id: String)
}

protocol MainPageViewInput: AnyObject {
    func setContentState(_ state: MainPageViewState)
}

enum MainPageViewState {
    case loading
    case content(_ models: [MainPageItemViewModel])
    case empty(_ model: EmptyViewModel)
}

final class MainPageViewController: UIViewController {
    private enum Constants {
        static let mediumPadding = 8.0
        static let largePadding = 16.0
        static let descriptionBlockHeight = 116.0
        
        static let navBarTitle = "Объявления"
        static let cellIdentifier = String(describing: MainPageItemViewCell.self)
    }
    
    private let output: MainPageViewOutput
    private var models: [MainPageItemViewModel] = []

    private var isFirstStart = true
    
    lazy private var contentCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewFlowLayout
        )
        view.showsVerticalScrollIndicator = false
        view.isHidden = true
        return view
    }()
    
    private let emptyView = EmptyView()
    private let loadingView = LoadingView()
    
    init(output: MainPageViewOutput) {
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
}

// MARK: - Private

private extension MainPageViewController {
    func configure() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        
        contentCollectionView.register(
            MainPageItemViewCell.self,
            forCellWithReuseIdentifier: Constants.cellIdentifier
        )
    }
    
    func setupLayout() {
        [contentCollectionView, emptyView, loadingView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [contentCollectionView, emptyView, loadingView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            contentCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            contentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}

// MARK: - MainPageViewInput

extension MainPageViewController: MainPageViewInput {
    func setContentState(_ state: MainPageViewState) {
        contentCollectionView.isHidden = true
        emptyView.isHidden = true
        loadingView.isHidden = true
        
        loadingView.stop()
        
        switch state {
        case .loading:
            navigationItem.title = .none
            loadingView.play(animationName: isFirstStart ? "data-splash-screen" : "data-loader")
            loadingView.isHidden = false
            isFirstStart = false
        case let .content(models):
            navigationItem.title = Constants.navBarTitle
            self.models = models
            contentCollectionView.reloadData()
            contentCollectionView.isHidden = false
        case let .empty(model):
            navigationItem.title = .none
            emptyView.configure(with: model)
            emptyView.isHidden = false
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let space: CGFloat = Constants.mediumPadding + (Constants.largePadding * 2)
        let imageWidth: CGFloat = (contentCollectionView.frame.size.width - space) / 2.0
        
        return CGSize(width: imageWidth, height: imageWidth + Constants.descriptionBlockHeight)
    }
}

// MARK: - UICollectionViewDataSource

extension MainPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.cellIdentifier,
            for: indexPath
        ) as? MainPageItemViewCell
        
        cell?.configure(with: models[indexPath.item])
        
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension MainPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.item]
        output.didTapItem(with: model.id)
    }
}

// MARK: - UICollectionViewFlowLayout

private extension MainPageViewController {
    var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.mediumPadding
        layout.minimumInteritemSpacing = Constants.mediumPadding
        layout.sectionInset = UIEdgeInsets(
            top: Constants.mediumPadding,
            left: Constants.largePadding,
            bottom: .zero,
            right: Constants.largePadding
        )
        return layout
    }
}
