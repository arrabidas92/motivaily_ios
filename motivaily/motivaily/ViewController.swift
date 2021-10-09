//
//  ViewController.swift
//  motivaily
//
//  Created by Alexandre DUARTE on 09/10/2021.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    // MARK: - UI
    
    private let primaryColor = UIColor(named: "primaryColor")!
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Quote of the day"
        label.font = UIFont(name: "Futura-MediumItalic", size: 32)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardView: CardView = {
        let cardView = CardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private lazy var shareButton: UIButton = {
        let icon = UIImage(named: "shareIcon")?.withTintColor(primaryColor)
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .white
        button.setImage(icon, for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 2.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - ViewModel
    
    private let viewModel = ViewModel(repository: FirestoreRepository())
    private var viewModelSubscriber: Set<AnyCancellable> = Set()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        print("ViewController::viewDidLoad")
        super.viewDidLoad()
        initUI()
        bindViewModel()
        viewModel.fetchQuote()
    }
    
    deinit {
        print("ViewController::deinit")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    
    @objc private func shareQuote(_ sender: UIButton) {
        viewModel.shareQuote()
    }
    
    // MARK: - Private helpers
    
    private func initUI() {
        view.backgroundColor = primaryColor
        
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
        view.addSubview(shareButton)
        shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shareButton.layer.cornerRadius = 25
        shareButton.addTarget(self, action: #selector(shareQuote), for: .touchUpInside)
        
        view.addSubview(cardView)
        cardView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 32).isActive = true
        cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        cardView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -32).isActive = true
        
        cardView.startLoading()
    }
    
    private func bindViewModel() {
        viewModel.$quote.sink(receiveValue: { [weak self] quote in
            guard !quote.isEmpty else { return }
            self?.cardView.stopLoading()
            self?.cardView.setQuote(quote.text)
        }).store(in: &viewModelSubscriber)
        
        viewModel.$error.sink(receiveValue: { [weak self] error in
            guard let error = error else { return }
            self?.cardView.stopLoading()
            switch error {
            case .noDataError:
                self?.showAlert(error: "There is no quote of the day")
            case .requestError:
                self?.showAlert(error: "A network error occured")
            }
        }).store(in: &viewModelSubscriber)
        
        viewModel.$sharedQuote.sink(receiveValue: { [weak self] sharedQuote in
            guard let sharedQuote = sharedQuote else { return }
            self?.shareQuoteWithActivityVC(sharedQuote.text)
        }).store(in: &viewModelSubscriber)
    }
    
    private func showAlert(error: String) {
        let alert = UIAlertController(title: "Network error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    private func shareQuoteWithActivityVC(_ text: String) {
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = []
        present(activityViewController, animated: true, completion: nil)
    }
}
