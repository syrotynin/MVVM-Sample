//
//  Track.swift
//  MVVM-Sample
//
//  Created by Serhii Syrotynin on 6/27/17.
//  Copyright © 2017 Serhii Syrotynin. All rights reserved.
//

import Foundation

struct Track {
    let title: String
    let url: URL
    
    enum ImageFormat: String {
        case px30 = "artworkUrl30"
        case px60 = "artworkUrl60"
        case px100 = "artworkUrl100"
        
        static let array = [px30, px60, px100]
        
        var intValue: Int {
            switch self {
            case .px100:
                return 100
            case .px60:
                return 60
            case .px30:
                return 30
            }
        }
    }
}
