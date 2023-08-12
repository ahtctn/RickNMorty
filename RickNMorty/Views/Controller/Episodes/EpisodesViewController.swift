//
//  EpisodesViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import UIKit

class EpisodesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private let viewModel = EpisodesViewModel()
    
    private var isFiltering: Bool {
        var textFieldCount: Int = searchTextField.text!.count
        return textFieldCount > 3 ? true : false
    }
    
    let selectedImage = UIImage(named: "tv")
    let unselectedImage = UIImage(named: "tvUnselected")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegations()
        observeEvent()
        setTabbarImage()
        tabbarDelegations()
    }
    
    private func tabbarDelegations() {
        self.tabBarController?.navigationItem.title = "Episodes"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "greenColor")
        let attirbutes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = attirbutes
    }
    
    private func delegations() {
        DispatchQueue.main.async {
            self.searchTextField.delegate = self
            self.searchTextField.addTarget(self, action: #selector(self.searchTextFieldDidChange(_:)), for: .editingChanged)
            
            self.tableView.register(UINib(nibName: "EpisodesTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellId)
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 100 // Örneğin, ortalama bir hücre yüksekliği
        }
    }
    
    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
        if let textToEnter = textField.text {
            DispatchQueue.main.async {
                Filtering.filterAndReloadData(with: textToEnter, reloadDataFunction: {
                    self.viewModel.searchEpisodes(with: textToEnter)
                }, tableView: self.tableView)
            }
        } else {
            Filtering.filterAndReloadData(with: "", reloadDataFunction: self.viewModel.getEpisodes, tableView: self.tableView)
        }
    }
    
    private func setTabbarImage() {
        tabBarItem = UITabBarItem(title: "", image: unselectedImage, selectedImage: selectedImage)
    }
    
    private func observeEvent() {
        viewModel.getEpisodes()
        
        viewModel.eventHandler = { [weak self ] event in
            switch event {
            case .loading:
                print("data is loading")
            case .stopLoading:
                print("data stopped loading")
            case .dataLoaded:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .error(let error):
                print("error in observe event function in episodesviewcontroller \(String(describing: error?.localizedDescription))")
            }
        }
    }

}

extension EpisodesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.viewModel.filteredEpisodes.count
        } else {
            return self.viewModel.numberOfRows()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: ResultEpisodesModel
        
        if isFiltering {
            item = viewModel.filteredEpisodes[indexPath.row]
        } else {
            item = self.viewModel.resultCell(at: indexPath.row)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? EpisodesTableViewCell else {
            print("tableviewcell error")
            return UITableViewCell()
        }
        
        cell.configure(with: item)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedEpisode: ResultEpisodesModel
        if isFiltering {
            selectedEpisode = viewModel.filteredEpisodes[indexPath.row]
        } else {
            selectedEpisode = viewModel.resultCell(at: indexPath.row)
        }
        performSegue(withIdentifier: Constants.cellId, sender: selectedEpisode)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        
        if scrollOffset <= 100 {
            self.viewModel.getPrevPage()
        }
        else if scrollOffset + scrollViewHeight >= scrollContentSizeHeight - 100 {
            self.viewModel.getNextPage()
        }
        
        if scrollOffset > 0 {
            if searchTextField.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.3) {
                    self.searchTextField.frame.origin.y = -self.searchTextField.frame.height
                }
            }
        } else {
            if searchTextField.frame.origin.y < 0 {
                UIView.animate(withDuration: 0.3) {
                    self.searchTextField.frame.origin.y = 0
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case segue.identifier = Constants.cellId {
            if let detailVC = segue.destination as? EpisodesDetailViewController,
               let selectedEpisode = sender as? ResultEpisodesModel {
                detailVC.episodes = selectedEpisode
                
            }
        }
    }
}
