//
//  DetailsPagePresenter.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 28.08.2023.
//

import Foundation

final class DetailsPagePresenter {
    
    private let itemId: String
    private let networkManager: NetworkManagerProtocol
    private let dateFormatterHelper = DateFormatterHelper()
    
    private var resultLoadingHandler: (() -> (Result<DetailsPageModel, Error>))?
    private var timer: Timer? {
        willSet { timer?.invalidate() }
    }
    
    weak var view: DetailsPageViewInput?
    
    init(
        itemId: String,
        networkManager: NetworkManagerProtocol
    ) {
        self.itemId = itemId
        self.networkManager = networkManager
    }
    
    deinit {
        timer?.invalidate()
    }
}

// MARK: - Private

private extension DetailsPagePresenter {
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
        
        networkManager.loadDetails(id: itemId) { [weak self] result in
            if self?.timer?.isValid == true {
                self?.resultLoadingHandler = { result }
                return
            }
            
            self?.update(result: result)
        }
    }
    
    func update(result: Result<DetailsPageModel, Error>) {
        DispatchQueue.main.async {
            switch result {
            case let .success(model):
                self.updateContentViewState(with: model)
            case .failure:
                self.updateErrorViewState()
            }
        }
    }
    
    func updateContentViewState(with model: DetailsPageModel) {
        view?.setContentState(
            .content(configureContentModel(model))
        )
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
    
    func configureContentModel(_ model: DetailsPageModel) -> DetailsPageViewModel {
        DetailsPageViewModel(
            title: model.title,
            price: model.price,
            imageUrl: model.imageUrl,
            createdDate: configureViewDate(from: model.createdDate),
            description: model.description,
            email: model.email,
            phoneNumber: model.phoneNumber,
            address: model.location + ", " + model.address
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

extension DetailsPagePresenter: DetailsPageViewOutput {
    func viewDidLoad() {
        loadMainPage()
    }
}
