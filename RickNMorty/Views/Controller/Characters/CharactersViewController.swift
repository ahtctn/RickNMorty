//
//  CharactersViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import UIKit

class CharactersViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var viewModel = CharactersViewModel()
    
    private var isFiltering: Bool {
        return !searchTextField.text!.isEmpty
    }
    
    let searchBar = UISearchBar()
    
    let selectedImage = UIImage(named: "characters")
    let unselectedImage = UIImage(named: "charactersUnselected")
    
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
        //searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        tableView.register(UINib(nibName: "CharactersTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 // Örneğin, ortalama bir hücre yüksekliği
    }
    
    private func observeEvent() {
        viewModel.getCharacters()
        
        viewModel.eventHandler = { [weak self] event in
            
            switch event {
            case .loading:
                print("data is loading")
            case .stopLoading:
                print("data stopped loading")
            case .dataLoaded:
                print("data loaded")
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .error(let error):
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    private func setTabbarImage() {
        tabBarItem = UITabBarItem(title: "", image: unselectedImage, selectedImage: selectedImage)
    }
    
    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
        if let textToEnter = textField.text {
            if textToEnter.isEmpty || textToEnter.count < 3 {
                DispatchQueue.main.async {
                    self.viewModel.getCharacters()
                    self.tableView.reloadData()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.viewModel.searchCharacters(with: textToEnter)
                    self.tableView.reloadData()
                }
            }
        }
    }

}

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.viewModel.filteredCharacters.count
        } else {
            return self.viewModel.numberOfRows()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: ResultsModel
        
        if isFiltering {
            item = viewModel.filteredCharacters[indexPath.row]
        } else {
            item = viewModel.resultCell(at: indexPath.row)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? CharactersTableViewCell else {
            print("tableviewcell error")
            return UITableViewCell()
        }
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCharacter: ResultsModel
        
        if isFiltering {
            selectedCharacter = viewModel.filteredCharacters[indexPath.row]
        } else {
            selectedCharacter = viewModel.resultCell(at: indexPath.row)
        }
        
        if let charactersDetailVC = storyboard?.instantiateViewController(withIdentifier: Constants.goToCharacterDetailFromEpisodesID) as? CharactersDetailViewController {
            charactersDetailVC.character = selectedCharacter
            navigationController?.pushViewController(charactersDetailVC, animated: true)
        }
        
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
}

