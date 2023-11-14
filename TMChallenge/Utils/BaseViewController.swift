//
//  BaseViewController.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import UIKit

class BaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = traitCollection.userInterfaceStyle == .light ? .white : .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupUI() { }
    
    func bindViewModel() { }
    
    func setupNavigationBar() { 
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
