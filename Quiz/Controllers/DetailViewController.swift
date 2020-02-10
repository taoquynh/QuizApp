//
//  DetailViewController.swift
//  Quiz
//
//  Created by Quynh on 2/10/20.
//  Copyright © 2020 Quynh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.29, green:0.75, blue:0.65, alpha:1.0)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.bounces = false
        return tableView
    }()

    let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Kiểm tra", for: .normal)
        button.backgroundColor = UIColor(red:0.29, green:0.75, blue:0.65, alpha:1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var heightBar: CGFloat!
    
    var data: Test?
    // bộ câu hỏi
    var questions: [Question]{
        return data?.questions ?? [Question]()
    }
    // index câu hiện tại
    var currentIndexQuestion: Int = 0
    // câu hỏi hiện tại
    var currentQuestion: Question{
        return questions[currentIndexQuestion]
    }
    // tổng số câu hỏi
    var totalQuestion: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightBar = UIApplication.shared.statusBarFrame.size.height +
        (navigationController?.navigationBar.frame.height ?? 0.0)
        
        setupNavigationBar()
        setupLayout()
        configTableView()
        getQuestion(currentIndexQuestion)
        totalQuestion = questions.count
        currentIndexQuestion = 0
        gesture()
        if totalQuestion > 1{
            submitButton.isHidden = true
        }
        submitButton.addTarget(self, action: #selector(submitResult), for: .touchUpInside)
    }
    
    // khi view chuẩn bị xuất hiện sẽ setup các thuộc tính của navigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set cho navigationBar trong suốt để thấy ảnh ở background (cần đủ 3 dòng)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    func setupNavigationBar(){
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back))
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func back(){
        dismiss(animated: false, completion: nil)
    }
    
    func setupLayout(){
        view.addSubview(topView)
        view.addSubview(tableView)
        
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20 + heightBar).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        topView.addSubview(questionLabel)
        questionLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        questionLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20).isActive = true
        questionLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20).isActive = true
        questionLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -20).isActive = true
        
        view.addSubview(submitButton)
        submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -20).isActive = true
    }
    
    func configTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    
    func getQuestion(_ current: Int){
        questionLabel.text = questions[current].question
    }
    
    func gesture(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func swipeLeft(){
        if currentIndexQuestion != totalQuestion - 1 {
            nextAnswer()
        }
    }
    
    @objc func swipeRight(){
        if currentIndexQuestion > 0 {
            previousAnswer()
        }
    }
    
    func nextAnswer(){
        // mỗi lần next, giá trị câu hỏi hiện tại tăng lên 1
        currentIndexQuestion += 1
        
        // kiểm tra câu hỏi hiện tại, nếu lớn hơn tổng số câu
        if currentIndexQuestion == totalQuestion - 1 {
            currentIndexQuestion = totalQuestion - 1
            submitButton.isHidden = false
        }
        getQuestion(currentIndexQuestion)
        tableView.reloadData()
    }
    
    func previousAnswer(){
        // mỗi lần back thì câu hỏi hiện tại trừ 1
        currentIndexQuestion -= 1
        
        if currentIndexQuestion <= 0 {
            currentIndexQuestion = 0
        }
        getQuestion(currentIndexQuestion)
        tableView.reloadData()
    }
    
    @objc func submitResult(){
        var point: Int = 0
        for item in questions{
            for (index, i) in item.answers.enumerated(){
                if i.isSelected == true && index + 1 == item.indexRightAnswer{
                    point += 1
                    i.isSelected = false
                }
            }
        }
        let resultVC = ResultViewController()
        resultVC.totalQuestion = totalQuestion
        resultVC.numberCorrect = point
        navigationController?.pushViewController(resultVC, animated: true)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let answer = currentQuestion.answers[indexPath.row]
        cell.answer = answer
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for item in currentQuestion.answers{
            item.isSelected = false
        }
        currentQuestion.answers[indexPath.row].isSelected = true
        tableView.reloadData()
    }
}
