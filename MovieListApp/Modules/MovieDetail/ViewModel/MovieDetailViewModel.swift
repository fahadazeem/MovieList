//
//  MovieDetailViewModel.swift
//  MovieListApp
//
//  Created by Junaid Butt on 26/05/2022.
//


import Foundation
import Alamofire

class MovieDetailViewModel {
    weak var delegate: MovieDetailViewModelDelegate!
    
    func movieDetail(_ id: String) {
        let url = Constant.BASE_URL + "?apikey=" + Constant.API_KEY + "&i=" + id
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(urlString!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { response in
            
            if response.error == nil {
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let json = utf8Text.data(using: .utf8)
                    print(utf8Text)
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(Movie.self, from: json!)
                        self.delegate.updateView(result)
                    } catch let error {
                        self.delegate.errorMessage(error.localizedDescription)
                    }
                }
            }
        }
    }
}

protocol MovieDetailViewModelDelegate: AnyObject {
    func updateView(_ data: Movie)
    func errorMessage(_ message: String)
}
