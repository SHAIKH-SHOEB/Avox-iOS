//
//  VideosTableViewCell.swift
//  Avox
//
//  Created by Nimap on 26/02/24.
//

import UIKit
import AVFoundation

class VideosTableViewCell: UITableViewCell, ASAutoPlayVideoLayerContainer {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playIconImageView: UIImageView!
    
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadBaseView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.imageURL = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.frame = CGRect(x: 0, y: 0, width: thumbnailImageView.frame.size.width, height: thumbnailImageView.frame.size.height)
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(thumbnailImageView.frame, from: thumbnailImageView)
        guard let videoFrame = videoFrameInParentSuperView, let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
    func loadBaseView() {
        baseView.backgroundColor = Helper.Color.bgPrimary
        
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        thumbnailImageView.clipsToBounds = true
        
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        thumbnailImageView.layer.addSublayer(videoLayer)
        
        profileNameLabel.font = UIFont.appFontBold(ofSize: 15.0)
        profileNameLabel.textColor = Helper.Color.textPrimary
    }
    
    func updateTableViewCellForVideo(model: Videos) {
        profileNameLabel.text = model.user!.name
        thumbnailImageView.imageURL = model.image
        videoURL = model.video_files?[1].link
    }
    
    func updateTableViewCellForCollections(model: Media) {
        if model.type == .video {
            profileNameLabel.text = model.user!.name
            thumbnailImageView.imageURL = model.image
            videoURL = model.videoFiles?[1].link
            playIconImageView.isHidden = false
        }else {
            thumbnailImageView.downloadImage(from: URL(string: "\(model.src!.original)")!, placeholder: UIImage(named: "Placeholder"))
            profileNameLabel.text = model.photographer
            playIconImageView.isHidden = true
        }
    }
}
