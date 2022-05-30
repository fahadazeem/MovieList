//
//  MovieDetailViewController.swift
//  MovieListApp
//
//  Created by Junaid Butt on 25/05/2022.
//

import UIKit
import SDWebImage
class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    var imdbID : String = ""
    private lazy var viewModel: MovieDetailViewModel = {
        let vm = MovieDetailViewModel()
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Connectivity.isConnectedToInternet {
            self.callMovieDetailApi()
        }
    }
    
    func callMovieDetailApi() {
        self.showActivityView()
        viewModel.movieDetail(self.imdbID)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - ViewModel Delagte
extension MovieDetailViewController: MovieDetailViewModelDelegate {
    
    func updateView(_ data: Movie) {
        self.hideActivityView()
        self.movieNameLabel.text = data.title
        self.movieDescriptionLabel.text = data.plot
        self.movieRatingLabel.text = data.imdbRating
        if let imageUrl = data.poster{
            if imageUrl == "N/A" {
                self.movieImage.image = UIImage(named: "movie")
            } else {
                self.movieImage.sd_setImage(with: URL(string:imageUrl), placeholderImage: nil)
                self.movieImage.layer.cornerRadius = 10
                self.movieImage.contentMode = .scaleToFill
                self.movieImage.clipsToBounds = true
            }
        } else {
            self.movieImage.image = UIImage(named: "movie")
        }
    }
    
    func errorMessage(_ message: String) {
        self.hideActivityView()
        self.showAlert(title: "Error!", message: message)
    }
}
