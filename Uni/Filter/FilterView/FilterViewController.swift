//
//  ViewController.swift
//  university
//
//  Created by Георгий Куликов on 11.10.2019.
//  Copyright © 2019 Георгий Куликов. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    private var dataFilter = Filter()
    
    private var presenter = FilterPresenter()
    
    private let constraints = Size()
    private let dataView = FilterViewData()
    
    private let dataSourceCountry = ["Москва", "Санкт-Петербург", "Омск", "Волгоград", "Владимир", "Екатеринбург", "Уфа", "Владивосток"]
    private let dataSourceSubject = ["Математика", "Русский", "Информатика", "Физика"]
    
    private var contentView = UIView()
    private var contentTable = UITableView()
    
    private let countryHeaderTitle: String = "Города"
    private var countryButton = UIDropDownButton()
    
    private let subjectsHeaderTitle: String = "Предметы"
    private var subjectsButton = UIDropDownButton()
    
    private var dataContentTable: [[UIDropDownButton]] = []
    private var dataHeaderTitle: [String] = []
    
    private let pointsSlider = UISlider()
    private let pointsTextField = UITextField()
    
    private let militaryLabel = UILabel()
    private let militaryButton = UISwitch()
    
    private let campusLabel = UILabel()
    private let campusButton = UISwitch()
    
    private func setConstraints(for view: Any, x: CGFloat, y:CGFloat, width: CGFloat, height: CGFloat) {
        
    }
    
    private func updateContentViewConstraints(y: CGFloat) {
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: constraints.contentViewY).isActive = true
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        
        contentView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: constraints.contentViewY).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: constraints.contentViewHeight).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func setupCountry(country: UIDropDownButton) {
        country.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        country.backgroundColor = dataView.FilterDropDownColor
        country.setTitle("Город", for: .normal)
        country.layer.cornerRadius = dataView.cornerRadius
        
        country.translatesAutoresizingMaskIntoConstraints = false
        
        country.widthAnchor.constraint(equalToConstant: self.view.center.x * 2 - constraints.safeAreaBorder).isActive = true
        
        country.dropView.dropDownOptions = dataSourceCountry
    }
    
    private func setupSubjects(subject: UIDropDownButton) {
        subject.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        subject.backgroundColor = dataView.FilterDropDownColor
        subject.setTitle("Предметы", for: .normal)
        subject.layer.cornerRadius = dataView.cornerRadius
        
        subject.translatesAutoresizingMaskIntoConstraints = false
        
        subject.widthAnchor.constraint(equalToConstant: self.view.center.x * 2 - constraints.safeAreaBorder).isActive = true
        
        subject.dropView.dropDownOptions = dataSourceSubject
    }
    
    private func setupDataContentTable() {
        view.addSubview(contentTable)
        
        dataContentTable.append([])
        dataContentTable.append([])
        pushCountry()
        pushSubject()
        
        dataHeaderTitle.append(countryHeaderTitle)
        dataHeaderTitle.append(subjectsHeaderTitle)
        
        contentTable.translatesAutoresizingMaskIntoConstraints = false

        contentTable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        contentTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: constraints.countryButtonY).isActive = true
        contentTable.widthAnchor.constraint(equalToConstant: self.view.center.x * 2 - constraints.safeAreaBorder).isActive = true
        contentTable.heightAnchor.constraint(equalToConstant: constraints.countryButtonHeight).isActive = true
        
        contentTable.delegate = self
        contentTable.dataSource = self
    }
    
    private func setupPointsSlider() {
        pointsSlider.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        pointsSlider.tintColor = dataView.sliderColor
        
        pointsSlider.minimumValue = 0
        pointsSlider.maximumValue = Float(dataContentTable[1].count * 100)
        
        pointsSlider.isContinuous = true
        pointsSlider.addTarget(self, action: #selector(changePoints), for: .valueChanged)
        
        contentView.addSubview(pointsSlider)
        
        pointsSlider.translatesAutoresizingMaskIntoConstraints = false
        
        pointsSlider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: constraints.safeAreaBorder).isActive = true
        pointsSlider.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.pointsSliderY).isActive = true
        pointsSlider.widthAnchor.constraint(equalToConstant: self.view.center.x * 2 - constraints.safeAreaBorder * 2).isActive = true
        pointsSlider.heightAnchor.constraint(equalToConstant: constraints.pointsSliderHeight).isActive = true
    }
    
    private func setupPointsTextField() {
        pointsTextField.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        pointsTextField.layer.cornerRadius = 10
        pointsTextField.layer.borderColor = UIColor.black.cgColor
        pointsTextField.layer.borderWidth = 1
        
        pointsTextField.placeholder = " Минимальный балл "
        pointsTextField.contentHorizontalAlignment = .left
        
        pointsTextField.delegate = self
        
        contentView.addSubview(pointsTextField)
        
        pointsTextField.translatesAutoresizingMaskIntoConstraints = false
        pointsTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: constraints.safeAreaBorder).isActive = true
        pointsTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.pointsTextFieldY).isActive = true
        pointsTextField.heightAnchor.constraint(equalToConstant: constraints.pointsTextFieldHeight).isActive = true
    }
    
    private func setupPoints() {
        setupPointsSlider()
        setupPointsTextField()
    }
    
    private func setupMilitaryLabel() {
        contentView.addSubview(militaryLabel)
        
        militaryLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        militaryLabel.text = "Военная Кафедра"
        
        militaryLabel.translatesAutoresizingMaskIntoConstraints = false

        militaryLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: constraints.safeAreaBorder).isActive = true
        militaryLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.militaryLabelY).isActive = true
        militaryLabel.heightAnchor.constraint(equalToConstant: constraints.militaryLabelHeight).isActive = true
    }
    
    private func setupMilitaryButton() {
        contentView.addSubview(militaryButton)
        
        militaryButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        militaryButton.isOn = true
        militaryButton.onTintColor = dataView.militaryButtonColor
        
        militaryButton.translatesAutoresizingMaskIntoConstraints = false
        
        militaryButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -constraints.safeAreaBorder).isActive = true
        militaryButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.militaryButtonY).isActive = true
    }
    
    private func setupMilitary() {
        setupMilitaryLabel()
        setupMilitaryButton()
    }
    
    private func setupCampusLabel() {
        campusLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        campusLabel.text = "Общежитие"
        
        contentView.addSubview(campusLabel)
        
        campusLabel.translatesAutoresizingMaskIntoConstraints = false

        campusLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: constraints.safeAreaBorder).isActive = true
        campusLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.campusLabelY).isActive = true
        campusLabel.heightAnchor.constraint(equalToConstant: constraints.campusLabelHeight).isActive = true
    }
    
    private func setupCampusButton() {
        contentView.addSubview(campusButton)
        
        campusButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        campusButton.isOn = true
        campusButton.onTintColor = dataView.campusButtonColor
        
        campusButton.translatesAutoresizingMaskIntoConstraints = false
        
        campusButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -constraints.safeAreaBorder).isActive = true
        campusButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraints.campusButtonY).isActive = true
    }
    
    private func setupCampus() {
        setupCampusLabel()
        setupCampusButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = dataView.FilterViewColor
        
        setupDataContentTable()
        
        setupContentView()
        
        setupPoints()
        setupMilitary()
        setupCampus()
    }
    
    private func fillDataFilter() {
        presenter.changeMinPoint(for: Int(pointsSlider.value))
        presenter.changeMilitary(for: militaryButton.isOn)
        presenter.changeCampus(for: campusButton.isOn)
    }
    
    @objc
    private func changePoints() {
        pointsTextField.text = " " + String(Int(pointsSlider.value))
    }
    
    @objc
    private func pushCountry() {
        let countryButton = UIDropDownButton()
        setupCountry(country: countryButton)
        
        dataContentTable[0].append(countryButton)
    }
    
    private func popCountry() {
        dataContentTable[0].removeLast()
    }
    
    @objc
    private func pushSubject() {
        let subjectButton = UIDropDownButton()
        setupSubjects(subject: subjectButton)
        
        dataContentTable[1].append(subjectButton)
        pointsSlider.maximumValue = Float(dataContentTable[1].count * 100)
    }
    
    private func popSubject() {
        dataContentTable[1].removeLast()
    }
}

extension FilterViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var num = Int(textField.text ?? "non num") {
            num = (Float(num) - pointsSlider.maximumValue) > .ulpOfOne ? 300 : num
            num = num < 0 ? 0 : num
            pointsSlider.value = Float(num)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FilterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataContentTable[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(dataContentTable[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataHeaderTitle[section]
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataContentTable.count
    }
}
