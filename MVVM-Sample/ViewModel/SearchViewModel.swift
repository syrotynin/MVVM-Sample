//
//  SearchViewModel.swift
//  MVVM-Sample
//
//  Created by Serhii Syrotynin on 6/26/17.
//  Copyright © 2017 Serhii Syrotynin. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import iTunesSearchAPI

class SearchViewModel {
    
    let searchString = Observable<String?>("")
    let validSearchText = Observable<Bool>(false)
    let searchResults = MutableObservableArray<Track>([])
    let searchInProgress = Observable<Bool>(false)
    let errorMessages = PublishSubject<String, NoError>()
    
    let itunes = iTunes()
    let settingsViewModel = SearchSettingsViewModel()
    
    init() {
        // search text validation
        searchString
            .map { $0!.characters.count > 3 }
            .bind(to:validSearchText)
        
        // execute search with 0.5 sec delay
        _ = searchString
            .filter { $0!.characters.count > 3 }
            .throttle(seconds: 0.5)
            .observeNext {
                [unowned self] text in
                if let text = text {
                    self.executeSearch(text)
                }
        }
        
        // execute search again if settings changed
        _ = settingsViewModel.imageFormat
            .throttle(seconds: 0.5)
            .observeNext {
                [unowned self] _ in
                self.executeSearch(self.searchString.value!)
        }
    }
    
    func executeSearch(_ text: String) {
        print(text)
        
        searchInProgress.value = true
        
        _ = itunes.search(for: text) { result in
            self.searchInProgress.value = false
            
            if let error = result.error {
                self.errorMessages.next(error.localizedDescription)
            } else {
                // clear previous results
                self.searchResults.removeAll()
                
                // convert the JSON response into a dictionary
                if let data = result.value as? [String : Any],
                let itunesData = data["results"] as? [[String : Any]] {
                    
                    let parsedTracks = itunesData.map {
                        trackDict -> Track? in
                        // parse each track instance - if an error occurs, return nil
                        guard let imageUrl = trackDict[self.settingsViewModel.imageFormat.value.rawValue] as? String,
                            let title = trackDict["trackName"] as? String,
                            let url = URL(string: imageUrl) else {
                                return nil
                        }
                        
                        return Track(title: title, url: url)
                        }
                        // flatMap to unwrap optionals and remove nils
                        .flatMap { $0 }
                    
                    self.searchResults.insert(contentsOf: parsedTracks, at: 0)
                }
            }
        }
    }
}
