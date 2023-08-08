//
//  EpisodesViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    @IBOutlet weak var headerView: HeaderGenericView!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = EpisodesViewModel()
    
    let selectedImage = UIImage(named: "tv")
    let unselectedImage = UIImage(named: "tvUnselected")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegations()
        observeEvent()
        setTabbarImage()
        setHeaderView()
    }
    
    private func delegations() {
        DispatchQueue.main.async {
            self.tableView.register(UINib(nibName: "EpisodesTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellId)
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 100 // Örneğin, ortalama bir hücre yüksekliği
        }
    }
    
    private func setTabbarImage() {
        tabBarItem = UITabBarItem(title: "", image: unselectedImage, selectedImage: selectedImage)
    }
    
    private func setHeaderView() {
        headerView.addLottieAnimation(animationName: Constants.HeaderAnimations.mortyTwerking)
        headerView.headerText.text = "episodes".capitalized
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
                print("error in observe event function in episodesviewcontroller \(error?.localizedDescription)")
            }
        }
    }
    
}

extension EpisodesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.viewModel.resultCell(at: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? EpisodesTableViewCell else {
            print("tableviewcell error")
            return UITableViewCell()
        }
        
        cell.configure(with: item)
        return cell
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedEpisode = viewModel.resultCell(at: indexPath.row)
        performSegue(withIdentifier: Constants.cellId, sender: selectedEpisode)
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
