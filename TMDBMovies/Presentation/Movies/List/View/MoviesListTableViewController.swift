//
//  MoviesListTableViewController.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 29/01/2024.
//

import UIKit

class MoviesListTableViewController: UITableViewController {

    static var identifier: String { String(describing: self) }
        
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    var fullPageLoadingSpinner: UIActivityIndicatorView?
    lazy var searchBar:UISearchBar = UISearchBar()

    var viewModel: MoviesListViewModel!
    private lazy var moviesUseCase: MoviesUseCase = {
        let moviesRepository: MoviesRepository = DefaultMoviesRepositoryImplementer()
        return DefaultMoviesUseCase(MoviesRepository: moviesRepository)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        setupUI()
        bindViewModel()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        loadData()
    }
    
    //MARK: - Private Methods
    private func loadData() {
        self.viewModel.update()
    }
    
    private func bindViewModel() {
        self.viewModel = MoviesListViewModel(MoviesUseCase: moviesUseCase)
         
        self.viewModel.moviesCompletionHandler = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        self.viewModel.loadingCompletionHandler = { [weak self] in
            guard let self = self else {
                return
            }
             
            self.updateLoading($0)
        }
        
        self.viewModel.error = { errorMsg in
            self.showAlert(with: errorMsg)
        }
    }
     
    private func updateLoading(_ loading: MoviesListViewModelLoading) {
        DispatchQueue.main.async {
            switch loading {
                case .fullScreen: self.handleFullPageLoading(isAnimating: true)
                case .nextPage, .none: self.handleFullPageLoading(isAnimating: false)
            }
            
            self.updateTableViewFooterLoading(loading)
        }
    }
    
    private func handleFullPageLoading(isAnimating: Bool) {
        if isAnimating {
            fullPageLoadingSpinner?.removeFromSuperview()
            fullPageLoadingSpinner = self.makeActivityIndicator(size: .init(width: self.view.frame.width, height: 44))
            self.view.addSubview(fullPageLoadingSpinner!)
            fullPageLoadingSpinner?.center = self.view.center
            fullPageLoadingSpinner?.startAnimating()
        } else {
            fullPageLoadingSpinner?.removeFromSuperview()
        }
    }
    
    func updateTableViewFooterLoading(_ loading: MoviesListViewModelLoading) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = tableView.makeActivityIndicator(size: .init(width: tableView.frame.width, height: 44))
            tableView.tableFooterView = nextPageLoadingSpinner
            case .fullScreen, .none:
                tableView.tableFooterView = nil
        }
    }
    
    private func setupUI () {
        self.title = "Movies"
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
    }
    
    private func setupTableView() {
        self.tableView.register(MovieListItemTableViewCell.nib(), forCellReuseIdentifier: MovieListItemTableViewCell.identifier)
        self.tableView.separatorStyle = .none
    }
    
    

}

extension MoviesListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        viewModel.didSearchChanged(searchKeywork: textSearched)
    }
}

extension MoviesListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.pages.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListItemTableViewCell.identifier, for: indexPath) as? MovieListItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.configureCellWithMovie(self.viewModel.getViewModel(for: indexPath))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedMovie = self.viewModel.didSelectItem(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.pages.movies.count-1 {
            self.viewModel.didLoadNextPage()
        }
    }
}

