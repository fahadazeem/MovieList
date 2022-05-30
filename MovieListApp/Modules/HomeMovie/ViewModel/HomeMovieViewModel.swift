//
//  HomeMovieViewModel.swift
//  MovieListApp
//
//  Created by Junaid Butt on 26/05/2022.
//

import Foundation
import Alamofire

class HomeMovieViewModel {
    weak var delegate: HomeMovieViewModelDelegate!
    var filterSearchArray: [Movie] = [] {
        didSet {
            self.delegate.updateCollectionView()
        }
    }
    
    var searchArray: [Movie] = []{
        didSet {
            self.delegate.updateCollectionView()
        }
    }
  
    func searchMovie(_ query: String){
        let url = Constant.BASE_URL + "?apikey=" + Constant.API_KEY + "&s=" + query
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(urlString!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { response in
            
            if response.error == nil {
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let json = utf8Text.data(using: .utf8)
                    print(utf8Text)
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(MovieModel.self, from: json!)
                        
                        if result.response  == "True" {
                            if result.search != nil{
                                self.searchArray = result.search ?? []
                                self.filterArray()
                            }else{
                                self.delegate.errorMessage(result.error ?? "Failed!")
                            }
                            
                        } else {
                            //completion(decodedJson, nil)
                            self.delegate.errorMessage(result.error ?? "")
                        }
                        
                    } catch let error {
                        self.delegate.errorMessage(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func filterArray() {
        self.filterSearchArray.removeAll()
        let hiddenArray = MoviePersistenceManager.shared.fetch().filter({$0.isHidden == true})
    
        for obj in self.searchArray {
            if !hiddenArray.contains(where: { $0.imdbID == obj.imdbID }){
                self.filterSearchArray.append(obj)
            }
        }
        self.delegate.updateCollectionView()
    }
    
    func getFavoriteMovies() -> [Movie] {
        let movies = MoviePersistenceManager.shared.fetch()
        return movies.filter({$0.isFavourite == true})
    }
    
    func getHiddenMovies() -> [Movie] {
        let movies = MoviePersistenceManager.shared.fetch()
        return movies.filter({$0.isHidden == true})
    }
}

protocol HomeMovieViewModelDelegate: AnyObject {
    func updateCollectionView()
    func errorMessage(_ message:String)
}
