//
//  SearchSettingsViewModel.swift
//  MVVM-Sample
//
//  Created by Serhii Syrotynin on 6/27/17.
//  Copyright © 2017 Serhii Syrotynin. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

class SearchSettingsViewModel {
    let minUploadDate = Observable<Date>(Date())
    let imageFormat = Observable<Track.ImageFormat>(Track.ImageFormat.px100)
    
    func formatIndex(_ format: Track.ImageFormat) -> Float {
        return Float(Track.ImageFormat.array.index(of: format) ?? 0)
    }
    
    func imageFormat(for index: Float) -> Track.ImageFormat {
        return Track.ImageFormat.array[Int(index)]
    }
}
