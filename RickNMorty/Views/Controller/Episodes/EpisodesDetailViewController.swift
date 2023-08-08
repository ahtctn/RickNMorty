//
//  EpisodesDetailViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 7.08.2023.
//

import UIKit

class EpisodesDetailViewController: UIViewController {
    
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var headerView: HeaderGenericView!
    @IBOutlet weak var tableView: UITableView!
    private var viewModel = CharactersViewModel()
    
    var episodes: ResultEpisodesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setHeaderView()
        
    }
    
    private func setHeaderView() {
        headerView.addLottieAnimation(animationName: Constants.HeaderAnimations.mortyTwerking)
        
        if let episode = episodes {
            headerView.headerText.text = episode.episode.capitalized
        }
        
    }
    
    private func delegations() {
        DispatchQueue.main.async {
            self.tableView.register(UINib(nibName: "CharactersTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellId)
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 100 // Örneğin, ortalama bir hücre yüksekliği
        }
    }
    
    private func setupUI() {
        if let episode = episodes {
            episodeLabel.text = episode.name
            nameLabel.text = episode.episode
            airDateLabel.text = episode.airDate
            print("Episode\(episode.episode)\nAirDate\(episode.airDate)\nID\(episode.id)\nCreated\(episode.created)\nUrl\(episode.url)\nCharacters\(episode.characters)\nName\(episode.name)")
        }
    }
}

extension EpisodesDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.viewModel.resultCell(at: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? CharactersTableViewCell else {
            print("tableViewcell error")
            return UITableViewCell()
        }
        
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
