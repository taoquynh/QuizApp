//
//  ResultViewController.swift
//  Quiz
//
//  Created by Quynh on 2/10/20.
//  Copyright © 2020 Quynh. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var totalQuestion: Int!
    var numberCorrect: Int!
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red:0.29, green:0.75, blue:0.65, alpha:1.0)
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupLayout()
        resultLabel.text = """
        SỐ CÂU ĐÚNG
        \(numberCorrect!)/\(totalQuestion!)
        """
    }
    
    func setupLayout(){
        view.addSubview(resultLabel)
        resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
    func setupNavigationBar(){
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back))
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func back(){
        navigationController?.popViewController(animated: true)
        dismiss(animated: false, completion: nil)
    }
}
