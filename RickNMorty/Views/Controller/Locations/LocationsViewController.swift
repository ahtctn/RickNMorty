//
//  LocationsViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 15.08.2023.
//

import UIKit
import Lottie

class LocationsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noResultView: NoResultView!
    
    private var lastContentOffset: CGFloat = 0.0
    
    private var searchTextFieldOriginalY: CGFloat = 0.0
    private var isSearchTextFieldVisible = true
    
    private let viewModel = LocationViewModel()
    
    private var isFiltering: Bool {
        let textFieldCount: Int = searchTextField.text!.count
        return textFieldCount > 3 ? true : false
    }

    private let selectedImage = UIImage(named: "earth")
    private let unSelectedImage = UIImage(named: "earthUnselected")
    
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
            
            let attirbutedString = NSMutableAttributedString(string: labelText)
            
            guard let greenColor = UIColor(named: "greenColor") else { fatalError("color error")}
            guard let orangeColor = UIColor(named: "orangeColor") else { fatalError("color error")}
            
            let rangeOfNoResults = (labelText as NSString).range(of: "No results for")
            attirbutedString.addAttribute(.foregroundColor, value: greenColor, range: rangeOfNoResults)
            
            let rangeOfSearchTextField = (labelText as NSString).range(of: textToEnter)
            attirbutedString.addAttribute(.foregroundColor, value: orangeColor, range: rangeOfSearchTextField)
            
            noResultView.noResultLabel.attributedText = attirbutedString
        }
    }
    
    private func tabbarDelegations() {
        self.tabBarController?.navigationItem.title = "Location"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "greenColor")
        let attirbutes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = attirbutes
    }
    
    private func setTabbarImage() {
        tabBarItem = UITabBarItem(title: "", image: unSelectedImage, selectedImage: selectedImage)
    }
    
    private func delegations() {
        DispatchQueue.main.async {
            self.searchTextField.delegate = self
            self.searchTextField.addTarget(self, action: #selector(self.searchTextFieldDidChange(_ :)), for: .editingChanged)
            self.tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellId)
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 100
        }
    }
    
    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
        if let textToEnter = textField.text {
            DispatchQueue.main.async {
                Filtering.filterAndReloadData(with: textToEnter, reloadDataFunction: {
                    self.viewModel.searchLocations(with: textToEnter)
                }, tableView: self.tableView)
                self.updateNoResultViewVisibility()
            }
        } else {
            Filtering.filterAndReloadData(with: "", reloadDataFunction: self.viewModel.getLocation, tableView: self.tableView)
            self.updateNoResultViewVisibility()
        }
    }
    
    private func updateNoResultViewVisibility() {
        if isFiltering && viewModel.filteredLocations.isEmpty {
            noResultView.isHidden = false
            setNoResultView()
        } else {
            noResultView.isHidden = true
        }
    }
    
    private func observeEvent() {
        viewModel.getLocation()
        
        viewModel.eventHandler = { [weak self] event in
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
                print("error in observe event function in locationsViewController \(String(describing: error?.localizedDescription))")
            }
        }
    }
}

extension LocationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.viewModel.filteredLocations.count
        } else {
            return self.viewModel.numberOfRows()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: ResultLocationModel
        
        if isFiltering {
            item = viewModel.filteredLocations[indexPath.row]
        } else {
            item = self.viewModel.resultCell(at: indexPath.row)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? LocationTableViewCell else {
            print("tableviewcell error")
            return UITableViewCell()
        }
        
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation: ResultLocationModel
        
        if isFiltering {
            selectedLocation = viewModel.filteredLocations[indexPath.row]
        } else {
            selectedLocation = viewModel.resultCell(at: indexPath.row)
        }
        
        performSegue(withIdentifier: Constants.cellId, sender: selectedLocation)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        
        if scrollOffset <= 100 {
            self.viewModel.getPrevPage()
        } else if scrollOffset + scrollViewHeight >= scrollContentSizeHeight - 100 {
            self.viewModel.getNextPage()
        }
        
        if scrollOffset == 0 || scrollOffset < lastContentOffset {
            UIView.animate(withDuration: 0.3) {
                self.searchTextField.isHidden = false
            }
        }
        
        else if scrollOffset > lastContentOffset {
            UIView.animate(withDuration: 0.3) {
                self.searchTextField.isHidden = true
            }
        }
        
        lastContentOffset = scrollOffset
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case segue.identifier = Constants.cellId {
            if let detailVC = segue.destination as? LocationsDetailViewController,
               let selectedLocation = sender as? ResultLocationModel {
                detailVC.locations = selectedLocation
            }
        }
    }
    
}


