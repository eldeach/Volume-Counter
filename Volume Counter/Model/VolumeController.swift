//
//  VolumeController.swift
//  Volume Counter
//
//  Created by 이돈형 on 2023/05/08.
//

import MediaPlayer

class VolumeController {
    
    var volumeView = MPVolumeView(frame: .zero)
    
    func setVolume(_ volume: Float) {
        let volumeSlider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        volumeSlider?.setValue(volume, animated: false)
    }
    
    func getVolume() -> Float {
        let volumeSlider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        return volumeSlider?.value ?? 0
    }
}

