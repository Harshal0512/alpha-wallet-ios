// Copyright © 2019 Stormbird PTE. LTD.

import UIKit

protocol CreateInitialWalletViewControllerDelegate: AnyObject {
    func didTapCreateWallet(inViewController viewController: CreateInitialWalletViewController)
    func didTapWatchWallet(inViewController viewController: CreateInitialWalletViewController)
    func didTapImportWallet(inViewController viewController: CreateInitialWalletViewController)
}

class CreateInitialWalletViewController: UIViewController {
    private let keystore: Keystore
    private var viewModel = CreateInitialViewModel()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    private let buttonsBar = VerticalButtonsBar(numberOfButtons: 1)
    private let secondaryButtonsBar = HorizontalButtonsBar(configuration: .secondary(buttons: 2))
    private let dividerView = UIView()
    private lazy var alreadyHaveWalletLabel: UILabel = {
        let alreadyHaveWalletLabel = UILabel()
        alreadyHaveWalletLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return alreadyHaveWalletLabel
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        return titleLabel
    }()

    weak var delegate: CreateInitialWalletViewControllerDelegate?

    init(keystore: Keystore) {
        self.keystore = keystore
        super.init(nibName: nil, bundle: nil)
        
        let footerBar = UIView()
        footerBar.translatesAutoresizingMaskIntoConstraints = false
        footerBar.backgroundColor = .clear

        view.backgroundColor = Colors.darkBlue
        view.addSubview(footerBar)
        view.addSubview(imageView)
        view.addSubview(titleLabel)

        footerBar.addSubview(buttonsBar)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        footerBar.addSubview(dividerView)
        footerBar.addSubview(alreadyHaveWalletLabel)
        footerBar.addSubview(secondaryButtonsBar)

        let footerBottomConstraint = footerBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        footerBottomConstraint.constant = -(UIApplication.shared.bottomSafeAreaHeight + 20)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            buttonsBar.topAnchor.constraint(equalTo: footerBar.topAnchor),
            buttonsBar.leadingAnchor.constraint(equalTo: footerBar.leadingAnchor, constant: 20),
            buttonsBar.trailingAnchor.constraint(equalTo: footerBar.trailingAnchor, constant: -20),
            
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: buttonsBar.bottomAnchor, constant: 30),
            
            alreadyHaveWalletLabel.leadingAnchor.constraint(equalTo: footerBar.leadingAnchor, constant: 20),
            alreadyHaveWalletLabel.trailingAnchor.constraint(equalTo: footerBar.trailingAnchor, constant: -20),
            alreadyHaveWalletLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            
            secondaryButtonsBar.topAnchor.constraint(equalTo: alreadyHaveWalletLabel.bottomAnchor, constant: 10),
            secondaryButtonsBar.leadingAnchor.constraint(equalTo: footerBar.leadingAnchor, constant: 20),
            secondaryButtonsBar.trailingAnchor.constraint(equalTo: footerBar.trailingAnchor, constant: -20),
            secondaryButtonsBar.bottomAnchor.constraint(equalTo: footerBar.bottomAnchor),

            footerBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerBottomConstraint,
        ])
        let colorTop = UIColor.white.cgColor
        let colorBottom = UIColor.black.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        view.layer.addSublayer(gradientLayer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = UIKitFactory.defaultView(autoResizingMarkIntoConstraints: true)
    }

    func configure() {
        imageView.image = viewModel.imageViewImage
        titleLabel.attributedText = viewModel.titleAttributedString

        let createWalletButton = buttonsBar.buttons[0]
        createWalletButton.setTitle(viewModel.createWalletButtonTitle, for: .normal)
        createWalletButton.addTarget(self, action: #selector(createWalletSelected), for: .touchUpInside)
        
        dividerView.backgroundColor = Colors.darkGray
        
        alreadyHaveWalletLabel.attributedText = viewModel.alreadyHaveWalletLabelAttributedString
        
        let secondButton1 = secondaryButtonsBar.buttons[0]
        secondButton1.setTitle(viewModel.watchButtonText, for: .normal)
        secondButton1.addTarget(self, action: #selector(createWalletSelected), for: .touchUpInside)
        
        let secondButton2 = secondaryButtonsBar.buttons[1]
        secondButton2.setTitle(viewModel.importButtonText, for: .normal)
        secondButton2.addTarget(self, action: #selector(createWalletSelected), for: .touchUpInside)
        
//        let alreadyHaveWalletButton = buttonsBar.buttons[1]
//        alreadyHaveWalletButton.setTitle(viewModel.alreadyHaveWalletButtonText, for: .normal)
//        alreadyHaveWalletButton.backgroundColor = UIColor(red: 0.02, green: 0.85, blue: 0.62, alpha: 1.00)
//        alreadyHaveWalletButton.addTarget(self, action: #selector(alreadyHaveWalletWallet), for: .touchUpInside)
    }

    @objc private func createWalletSelected(_ sender: UIButton) {
        delegate?.didTapCreateWallet(inViewController: self)
    }

    @objc private func alreadyHaveWalletWallet(_ sender: UIButton) {
        let viewController = makeAlreadyHaveWalletAlertSheet(sender: sender)
        present(viewController, animated: true)
    }

    private func makeAlreadyHaveWalletAlertSheet(sender: UIView) -> UIAlertController {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.popoverPresentationController?.sourceView = sender
        alertController.popoverPresentationController?.sourceRect = sender.centerRect

        let importWalletAction = UIAlertAction(title: viewModel.importButtonTitle, style: .default) { _ in
            self.delegate?.didTapImportWallet(inViewController: self)
        }

        let trackWalletAction = UIAlertAction(title: viewModel.watchButtonTitle, style: .default) { _ in
            self.delegate?.didTapWatchWallet(inViewController: self)
        }

        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel) { _ in }

        alertController.addAction(importWalletAction)
        alertController.addAction(trackWalletAction)
        alertController.addAction(cancelAction)

        return alertController
    }
}
