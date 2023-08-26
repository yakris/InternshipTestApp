//
//  MainPagePresenter.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 26.08.2023.
//

import Foundation

final class MainPagePresenter {
    private let router: MainPageRouterInput
    private let networkManager: NetworkManagerProtocol
    private let dateFormatterHelper = DateFormatterHelper()
    
    private var resultLoadingHandler: (() -> (Result<MainPageModel, Error>))?
    private var timer: Timer? {
        willSet { timer?.invalidate() }
    }
    
    weak var view: MainPageViewInput?
    
    init(
        router: MainPageRouterInput,
        networkManager: NetworkManagerProtocol
    ) {
        self.router = router
        self.networkManager = networkManager
    }
    
    deinit {
        timer?.invalidate()
    }
}

// MARK: - Private

private extension MainPagePresenter {
    func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            if let result = self?.resultLoadingHandler {
                self?.update(result: result())
            }
            
            self?.timer = nil
            self?.resultLoadingHandler = nil
        }
    }
    
    func loadMainPage() {
        view?.setContentState(.loading)
        setupTimer()
        
        networkManager.loadMainPage() { [weak self] result in
            if self?.timer?.isValid == true {
                self?.resultLoadingHandler = { result }
                return
            }
            
            self?.update(result: result)
        }
    }
    
    func update(result: Result<MainPageModel, Error>) {
        DispatchQueue.main.async {
            switch result {
            case let .success(model):
                self.updateContentViewState(with: model)
            case .failure:
                self.updateErrorViewState()
            }
        }
    }
    
    func updateContentViewState(with model: MainPageModel) {
        if model.advertisements.isEmpty {
            view?.setContentState(
                .empty(configureEmptyModel())
            )
        } else {
            view?.setContentState(
                .content(configureContentModel(model))
            )
        }
    }
    
    func updateErrorViewState() {
        view?.setContentState(
            .empty(configureErrorModel())
        )
    }
    
    func configureViewDate(from dateString: String) -> String {
        guard let date = dateFormatterHelper.createdDateFromBackend.date(from: dateString) else {
            return dateString
        }
        
        return dateFormatterHelper.createdDate.dateWithToday(date)
    }
    
    func configureContentModel(_ model: MainPageModel) -> [MainPageItemViewModel] {
        model.advertisements.compactMap {
            MainPageItemViewModel(
                id: $0.id,
                title: $0.title,
                price: $0.price,
                location: $0.location,
                imageUrl: $0.imageUrl,
                createdDate: configureViewDate(from: $0.createdDate)
            )
        }
    }
    
    func configureEmptyModel() -> EmptyViewModel {
        EmptyViewModel(
            title: "Объявлений пока нет",
            description: "Вы можете обновить страницу или\nпросто посмотреть на кота",
            actionHandler: loadMainPage
        )
    }
    
    func configureErrorModel() -> EmptyViewModel {
        EmptyViewModel(
            title: "Уупс, что-то пошло не так",
            description: "Кот тоже в шоке, но вы можете\nпопробовать еще раз",
            actionHandler: loadMainPage
        )
    }
}

// MARK: - MainPageViewOutput

extension MainPagePresenter: MainPageViewOutput {
    func viewDidLoad() {
        loadMainPage()
    }
    
    func didTapItem(with id: String) {
        router.showDetailScreen(with: id)
    }
}
