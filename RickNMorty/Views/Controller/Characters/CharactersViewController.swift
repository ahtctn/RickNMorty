//
//  CharactersViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import UIKit

class CharactersViewController: UIViewController {
    
    @IBOutlet weak var headerView: HeaderGenericView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var viewModel = CharactersViewModel()
    
    
    
    private var isFiltering: Bool {
        return !searchTextField.text!.isEmpty
    }
    
    
    
    let selectedImage = UIImage(named: "characters")
    let unselectedImage = UIImage(named: "charactersUnselected")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.isHidden = false
        delegations()
        observeEvent()
        setHeaderView()
        setTabbarImage()
    }
    
    private func delegations() {
        
        
        
        DispatchQueue.main.async {
            self.searchTextField.delegate = self
            self.searchTextField.addTarget(self, action: #selector(self.searchTextFieldDidChange(_:)), for: .editingChanged)
            
            self.tableView.register(UINib(nibName: "CharactersTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellId)
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 100 // Örneğin, ortalama bir hücre yüksekliği
        }
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
    
    private func setHeaderView() {
        self.headerView.headerText.text = "characters".capitalized
        self.headerView.addLottieAnimation(animationName: Constants.HeaderAnimations.mortyCrying)
    }
    
    private func setTabbarImage() {
        tabBarItem = UITabBarItem(title: "", image: unselectedImage, selectedImage: selectedImage)
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
        tableView.reloadData()
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

extension CharactersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            // Burada arama işlemlerini yapar
            viewModel.searchCharacters(with: searchText)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            // Arama metni boş ise, tüm karakterleri göster
            viewModel.getCharacters()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension CharactersViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchTextField {
            // Aramayı üçüncü karakterden sonra yap
            if textField.text!.count >= 3 {
                let searchString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                viewModel.searchCharacters(with: searchString)
            }
        }
        return true
    }
}
