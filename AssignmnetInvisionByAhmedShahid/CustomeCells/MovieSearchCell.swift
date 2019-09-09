//
//  MovieSearchCell.swift
//  AssignmnetInvisionByAhmedShahid
//
//  Created by Ahmed Shahid on 08/09/2019.
//  Copyright © 2019 Ahmed Shahid. All rights reserved.
//

import UIKit
import SDWebImage

class MovieSearchCell: UITableViewCell {

    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelMovieNameAndDate: UILabel!
    @IBOutlet weak var labelMovieDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindData(with movie: MovieResults?) {
        
        if let url = URL(string: Constants.IMAGE_BASEURL + (movie?.poster_path ?? "")) {
            self.imageViewPoster.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder-image"))
        } else {
            self.imageViewPoster.image = UIImage(named: "placeholder-image")
        }
        
        self.labelMovieNameAndDate.text = "\(movie?.title ?? "") (\(movie?.release_date ?? ""))"
        self.labelMovieDescription.text = movie?.overview ?? ""
    }
}
