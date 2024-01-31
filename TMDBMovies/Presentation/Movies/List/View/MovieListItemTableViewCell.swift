//
//  MovieListItemTableViewCell.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 29/01/2024.
//

import UIKit


class MovieListItemTableViewCell: UITableViewCell {
  
    static var identifier: String { String(describing: self) }
    
    @IBOutlet weak var moviewTitleLabel: UILabel!
    @IBOutlet weak var moviewReleaseYearLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    static func nib() -> UINib {
        let nib = UINib(nibName: MovieListItemTableViewCell.identifier, bundle: nil)
        return nib
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCellWithMovie(_ movieViewModel: MoviesListItemViewModel) {
        moviewTitleLabel.text = movieViewModel.title
        moviewReleaseYearLabel.text = movieViewModel.releaseDate
        
        let urlString = "https://image.tmdb.org/t/p/w500/\(movieViewModel.posterPath)"
        print(urlString)
        
        if let url = URL(string: urlString) {
            movieImageView.loadImage(from: url, identifier: "\(movieViewModel.id)")
        }
    }
}
