//
//  ASVideoLayerObject.swift
//  Avox
//
//  Created by Shaikh Shoeb on 04/08/24.
//

import UIKit
import AVFoundation
class ASVideoLayerObject: NSObject {
    var layer = AVPlayerLayer()
    var used = false
    override init() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.videoGravity = AVLayerVideoGravity.resize
    }
}

struct VideoLayers {
    var layers = Array<ASVideoLayerObject>()
    init() {
        for _ in 0..<1{
            layers.append(ASVideoLayerObject())
        }
    }
    
    func getLayerForParentLayer(parentLayer: CALayer) -> AVPlayerLayer {
        for videoObject in layers {
            if videoObject.layer.superlayer == parentLayer {
                return videoObject.layer
            }
        }
        return getFreeVideoLayer()
    }
    
    func getFreeVideoLayer() -> AVPlayerLayer {
        for videoObject in layers {
            if videoObject.used == false {
                videoObject.used = true
                return videoObject.layer
            }
        }
        return layers[0].layer
    }
    
    func freeLayer(layerToFree: AVPlayerLayer) {
        for videoObject in layers {
            if videoObject.layer == layerToFree {
                videoObject.used = false
                videoObject.layer.player = nil
                if videoObject.layer.superlayer != nil {
                    videoObject.layer.removeFromSuperlayer()
                }
                break
            }
        }
    }
}
