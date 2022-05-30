//
//  MovieCollectionViewCell.swift
//  MovieListApp
//
//  Created by Junaid Butt on 25/05/2022.
//

import UIKit
import SDWebImage

protocol Moviesdelegate {
    func addHiddenMovie()
    func reloadFavortieMovie()
}
class MovieCollectionViewCell: UICollectionViewCell {
    var delegate : Moviesdelegate!
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    var index : Int = 0
    var isfavorite : Bool = false
    var favouriteArray = MoviePersistenceManager.shared.fetch().filter({$0.isFavourite == true})
    
    var movie : Movie? {
        didSet {
            self.titleLabel.text = movie?.title
            if self.favouriteArray.contains(where: {$0.imdbID == movie!.imdbID}) {
                isfavorite = true
                self.favoriteButton.setImage(UIImage(named: "fav"), for: .normal)
                self.hideButton.isHidden = true
            } else {
                isfavorite = false
                self.favoriteButton.setImage(UIImage(named: "unFav"), for: .normal)
                self.hideButton.isHidden = false
            }
            if let imageUrl = movie?.poster {
                if imageUrl == "N/A" {
                    self.movieImage.backgroundColor =  UIColor.lightGray
                    self.movieImage.layer.cornerRadius = 20
                } else {
                    self.movieImage.sd_setImage(with: URL(string:imageUrl), placeholderImage: nil)
                    self.movieImage.layer.cornerRadius = 20
                    self.movieImage.contentMode = .scaleToFill
                    self.movieImage.clipsToBounds = true
                }
            } else {
                self.movieImage.backgroundColor =  UIColor.lightGray
                self.movieImage.layer.cornerRadius = 20
            }
        }
    }
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var favoriteButton : UIButton!
    @IBOutlet weak var hideButton : UIButton!
    @IBOutlet weak var movieImage : UIImageView! {
        didSet {
            self.movieImage.layer.cornerRadius = 5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        favouriteArray = MoviePersistenceManager.shared.fetch().filter({$0.isFavourite == true})
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        if self.movie != nil {
            var newMovie : Movie = self.movie!
            if !self.isfavorite {
                self.isfavorite = true
                newMovie.isFavourite = true
                MoviePersistenceManager.shared.save(movies: [newMovie])
                self.favoriteButton.setImage(UIImage(named: "fav"), for: .normal)
            } else {
                self.isfavorite = false
                newMovie.isFavourite = false
                MoviePersistenceManager.shared.save(movies: [newMovie])
                MoviePersistenceManager.shared.deleteMovie(id: (self.movie?.imdbID)!)
                self.favoriteButton.setImage(UIImage(named: "unFav"), for: .normal)
                delegate.reloadFavortieMovie()
            }
        }
        print(MoviePersistenceManager.shared.fetch().count)
    }
    
    @IBAction func hideAction(_ sender: UIButton) {
        if self.movie != nil {
            var newMovie : Movie = self.movie!
            newMovie.isHidden = true
            MoviePersistenceManager.shared.save(movies: [newMovie])
        }
        self.delegate.addHiddenMovie()
    }
    
}
