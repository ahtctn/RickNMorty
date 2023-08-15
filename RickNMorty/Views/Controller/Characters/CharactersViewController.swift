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
    @IBOutlet weak var noResultView: NoResultView!
    
    private var lastContentOffset: CGFloat = 0.0
    
    private var searchTextFieldOriginalY: CGFloat = 0.0
    private var isSearchTextFieldVisible = true
    
    private var viewModel = CharactersViewModel()
    
    private var isFiltering: Bool {
        let textFieldCount: Int = searchTextField.text!.count
        return textFieldCount > 3 ? true : false
    }
    
    let selectedImage = UIImage(named: "characters")
    let unselectedImage = UIImage(named: "charactersUnselected")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegations()
        observeEvent()
        setTabbarImage()
        tabbarDelegations()
        noResultView.isHidden = true
        
        searchTextFieldOriginalY = searchTextField.frame.origin.y
    }
    
    private func setNoResultView() {
        AnimationHelper.addLottieAnimation(animationName: "noResultBackgroundClouds", viewToAnimate: noResultView)
        AnimationHelper.addLottieAnimation(animationName: "noResultForeground", viewToAnimate: noResultView)
        
        if let textToEnter = searchTextField.text {
            let labelText = "No results for \(textToEnter)"
            
            let attributedString = NSMutableAttributedString(string: labelText)
            
            guard let greenColor = UIColor(named: "greenColor") else { fatalError("color error") }
            guard let orangeColor = UIColor(named: "orangeColor") else { fatalError("color Error")}
            
            let rangeOfNoResults = (labelText as NSString).range(of: "No results for")
            attributedString.addAttribute(.foregroundColor, value: greenColor, range: rangeOfNoResults)
            
            let rangeOfSearchTextField = (labelText as NSString).range(of: textToEnter)
            attributedString.addAttribute(.foregroundColor, value: orangeColor, range: rangeOfSearchTextField)
            
            noResultView.noResultLabel.attributedText = attributedString
        }
    }
    
    private func tabbarDelegations() {
        self.tabBarController?.navigationItem.title = "Characters"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "greenColor")
        let attirbutes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = attirbutes
    }
    
    private func delegations() {
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        tableView.register(UINib(nibName: "CharactersTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
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
            DispatchQueue.main.async {
                Filtering.filterAndReloadData(with: textToEnter, reloadDataFunction: {
                    self.viewModel.searchCharacters(with: textToEnter)
                }, tableView: self.tableView)
                self.updateNoResultViewVisibility()
            }
        }
        else {
            Filtering.filterAndReloadData(with: "", reloadDataFunction: self.viewModel.getCharacters, tableView: self.tableView)
            self.updateNoResultViewVisibility()
        }
    }
    
    private func updateNoResultViewVisibility() {
        if isFiltering && viewModel.filteredCharacters.isEmpty {
            noResultView.isHidden = false
            setNoResultView()
        } else {
            noResultView.isHidden = true
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: ResultsCharactersModel
        
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
        
        let selectedCharacter: ResultsCharactersModel
        
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
        
        if scrollOffset == 0 || scrollOffset < lastContentOffset {
            // En başta veya yukarıya kaydırma işlemi durduğunda
            UIView.animate(withDuration: 0.3) {
                self.searchTextField.isHidden = false
                
            }
        }
        else if scrollOffset > lastContentOffset {
            // Aşağıya kaydırma işlemi
            UIView.animate(withDuration: 0.3) {
                self.searchTextField.isHidden = true
                
            }
        }
        
        lastContentOffset = scrollOffset
    }
}




