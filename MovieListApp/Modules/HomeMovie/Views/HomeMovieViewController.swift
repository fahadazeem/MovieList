//
//  HomeMovieViewController.swift
//  MovieListApp
//
//  Created by Junaid Butt on 25/05/2022.
//

import UIKit
import NotificationBannerSwift
class HomeMovieViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var backView: UIView!
    private lazy var viewModel: HomeMovieViewModel = {
        let vm = HomeMovieViewModel()
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpCollectionView()
        self.setupSearchBar()
        viewModel.filterSearchArray = MoviePersistenceManager.shared.fetch().filter({$0.isFavourite == true})
    }
    
    func setupSearchBar() {
        searchBar.placeholder = "Search movie"
        searchBar.autocapitalizationType = .none
        searchBar.backgroundImage = UIImage()
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.clearButtonMode = .whileEditing
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setUpCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(MovieCollectionViewCell.nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
    }
}

// MARK: -Search Bar Delegate
extension HomeMovieViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        if searchBar.text?.count == 0 {
            viewModel.filterSearchArray.removeAll()
            self.collectionView.reloadData()
            viewModel.filterSearchArray = MoviePersistenceManager.shared.fetch().filter({$0.isFavourite == true})
        } else {
            if Connectivity.isConnectedToInternet {
                self.showActivityView()
                viewModel.filterSearchArray.removeAll()
                viewModel.searchArray.removeAll()
                viewModel.searchMovie(searchBar.text!)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.filterSearchArray.removeAll()
            self.collectionView.reloadData()
            viewModel.filterSearchArray = MoviePersistenceManager.shared.fetch().filter({$0.isFavourite == true})
        }
    }
}
// MARK: - collection view Delegate
extension HomeMovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filterSearchArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        cell.movie = viewModel.filterSearchArray[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailViewController.instantiateMain()
        vc.imdbID = viewModel.filterSearchArray[indexPath.row].imdbID!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - CollectionView Cll Delegate
extension HomeMovieViewController: Moviesdelegate {
    
    func reloadFavortieMovie() {
        if self.searchBar.text?.count == 0 {
            viewModel.filterSearchArray.removeAll()
            viewModel.filterSearchArray = MoviePersistenceManager.shared.fetch().filter({$0.isFavourite == true})
        } else {
            self.viewModel.filterSearchArray.removeAll()
            self.viewModel.filterArray()
        }
    }
    
    func addHiddenMovie() {
        if viewModel.searchArray.isEmpty {
            viewModel.filterSearchArray.removeAll()
            viewModel.filterSearchArray = MoviePersistenceManager.shared.fetch().filter({$0.isFavourite == true})
        } else {
            self.viewModel.filterSearchArray.removeAll()
            self.viewModel.filterArray()
            self.collectionView.reloadData()
        }
    }
}
// MARK: - ViewModel Delegate
extension HomeMovieViewController: HomeMovieViewModelDelegate {
    
    func updateCollectionView() {
        DispatchQueue.main.async {
            if self.viewModel.filterSearchArray.count == 0 {
                self.backView.isHidden = false
                self.collectionView.isHidden = true
            } else {
                self.backView.isHidden = true
                self.collectionView.isHidden = false
                self.hideActivityView()
                self.collectionView.reloadData()
            }
        }
    }
    
    func errorMessage(_ message: String) {
        self.hideActivityView()
        self.showAlert(title: "Error", message: message)
    }
}

// MARK: - collection view Flow Layout
extension HomeMovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = 5.0
        let size = collectionView.frame.size
        let width = ((size.width / 2.0) - spacing)
        return CGSize(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
