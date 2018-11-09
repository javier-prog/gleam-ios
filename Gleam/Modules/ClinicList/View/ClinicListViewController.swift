//
//  ClinicListViewController.swift
//  Gleam
//
//  Created by albert on 09/11/2018.
//  Copyright © 2018 Alexey Karataev. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ClinicListViewControllerInput
protocol ClinicListViewControllerInput: class {
    func renderClinics()
    func renderError(description: String)
}

// MARK: - ClinicListViewControllerOutput
protocol ClinicListViewControllerOutput: class {
    func clinicListViewControllerDidLoad(_ view: ClinicListViewController)
    func clinicListViewControllerGetRows(_ view: ClinicListViewController) -> Int
    func clinicListViewControllerGetCell(_ view: ClinicListViewController, tableView: UITableView, indexPath: IndexPath) -> ClinicTableViewCell
    func clinicListViewControllerLoadWithFilter(_ view: ClinicListViewController, text: String)
}

// MARK: - ClinicListViewController
class ClinicListViewController: UIViewController {
    
    private lazy var clinicListHeaderView = self.createHeaderView()
    private lazy var tableView = self.createTableView()
    
    var output: ClinicListViewControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ClinicListConfigurator.configure(self)
        registerCells()
        output.clinicListViewControllerDidLoad(self)
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarForClinicListViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Private methods
private extension ClinicListViewController {
    func registerCells() {
        tableView.register(ClinicTableViewCell.self, forCellReuseIdentifier: "ClinicTableViewCell")
    }
}

// MARK: - Methods for create UI elements
private extension ClinicListViewController {
    
    func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        return tableView
    }
    
    func createHeaderView() -> ClinicListHeaderView {
        let view = ClinicListHeaderView()
        view.delegate = self
        return view
    }
}

// MARK: - UITableViewDataSource
extension ClinicListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.clinicListViewControllerGetRows(self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return output.clinicListViewControllerGetCell(self, tableView: tableView, indexPath: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ClinicListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return clinicListHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return clinicListHeaderView.bounds.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ClinicListHeaderViewDelegate
extension ClinicListViewController: ClinicListHeaderViewDelegate {
    
    func searchBarTextDidChanged(_ clinicListHeaderView: ClinicListHeaderView, text: String) {
        output.clinicListViewControllerLoadWithFilter(self, text: text)
    }
    
    func searchBarDoneButtonTapped(_ clinicListHeaderView: ClinicListHeaderView) {
        view.endEditing(true)
    }
}


// MARK: - ClinicListViewControllerInput
extension ClinicListViewController: ClinicListViewControllerInput {
    
    func renderClinics() {
        tableView.reloadData()
    }
    
    func renderError(description: String) {
        let alertViewController = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertViewController, animated: true)
    }
}

// MARK: - GleamNavigationControllerStylable
extension ClinicListViewController: GleamNavigationControllerStylable { }