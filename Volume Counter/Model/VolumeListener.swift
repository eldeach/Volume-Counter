//
//  VolumeListener.swift
//  Volume Counter
//
//  Created by 이돈형 on 2023/05/08.
//

import SwiftUI
import AVFoundation
import RealmSwift

class VolumeListener: NSObject, ObservableObject {
    let realm = try! Realm()
    @ObservedResults(CounterDataModel.self) var cdms
    var cdmIndex:Int=0
    
    let audioSession = AVAudioSession.sharedInstance()
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    
    @objc dynamic var isVolumeIncreasing = false
    
    @objc dynamic var previousVolume: Float = 0
      
    var vc:VolumeController = VolumeController()
    
    @Published var audioInteruption:Bool = false
    
    override init() {
        super.init()
        // AVAudioSession을 사용하여 볼륨 버튼 이벤트 감지
        previousVolume=0.5
        
        registerForNotifications()
        
        do {
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setCategory(.playback)
            audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    deinit {
        // KVO 제거
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.removeObserver(self, forKeyPath: "outputVolume")
    }
    
    
    // KVO를 사용하여 볼륨 버튼 이벤트 감지
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            if let volume = change?[.newKey] as? Float, volume > 0 {
                // 볼륨 버튼 입력 시 outputVolume 업데이트
                if volume > previousVolume{
                    isVolumeIncreasing = true
                    try! realm.write{
                        cdms[cdmIndex].counted += 1
                    }
                } else if volume < previousVolume{
                    isVolumeIncreasing = false
                    if ((cdms[cdmIndex].counted - 1) < 0) {
                        try! realm.write{
                            cdms[cdmIndex].counted = 0
                        }
                    }
                    else{
                        try! realm.write{
                            cdms[cdmIndex].counted -= 1
                        }
                    }
                }
//                vc.setVolume(previousVolume)
                vc.setVolume(0.5)
            }
        }
    }
    
    func setCdmIndex(index:Int){
        self.cdmIndex = index
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
    }
     
    @objc func handleInterruption(_ notification: Notification) {
        audioInteruption = true
        print("audio interuption \(audioInteruption ? "TRUE" : "FALSE")")
        
    }
    
    func falseAudioInteruption(){
        audioInteruption = false
        print("audio interuption \(audioInteruption ? "TRUE" : "FALSE")")
    }
    
    func trueAudioInteruption(){
        audioInteruption = true
        print("audio interuption \(audioInteruption ? "TRUE" : "FALSE")")
    }
}
