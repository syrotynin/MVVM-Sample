//
//  SettingsViewController.swift
//  MVVM-Sample
//
//  Created by Serhii Syrotynin on 6/27/17.
//  Copyright © 2017 Serhii Syrotynin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var viewModel: SearchSettingsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.imageFormat
            .map { viewModel.formatIndex($0) }
            .bind(to: slider.reactive.value)
        
        viewModel.imageFormat
            .map { "Image Size \($0.intValue)x\($0.intValue)" }
            .bind(to: sizeLabel.reactive.text)
        
        _ = slider.reactive.value.observeNext {
            event in
            viewModel.imageFormat.value = viewModel.imageFormat(for: event)
        }
    }
}
