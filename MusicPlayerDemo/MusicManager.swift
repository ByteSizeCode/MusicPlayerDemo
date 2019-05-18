//
//  MusicManager.swift
//  MusicPlayerDemo
//
//  Created by Isaac Raval on 5/17/19.
//  Copyright © 2019 Isaac Raval. All rights reserved.
//

import Foundation
import AppKit
//import AudioToolbox
import AVFoundation
import Cocoa

class MusicManager : NSObject {
    
    func setup(forSong songFileName: String, withExtension songFileExten: String) {
        //Get where the file is
        let url = Bundle.main.url(forResource: songFileName, withExtension: songFileExten)
        //Put it in an AVAudioFile
        let audioFile = try! AVAudioFile(forReading: url!)
        //Get the audio file format
        let audioFormat = audioFile.processingFormat
        let audioFrameCount = UInt32(audioFile.length)
        //Print number of channels
        print(audioFile.fileFormat.channelCount)
        print(audioFrameCount)
        //Setup the buffer for audio data
        let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(audioFile.length))
        //Put audio data in the buffer
        try! audioFile.read(into: audioFileBuffer!)
        
        //Init engine and player
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.attach(audioPlayer)
        audioEngine.connect(audioPlayer, to:mainMixer, format: audioFileBuffer!.format)
        audioPlayer.scheduleBuffer(audioFileBuffer!, completionHandler: nil)
        audioEngine.prepare()
        do {
            try audioEngine.start()
            print("Audio Engine Started")
        } catch let error {
            print(error.localizedDescription)
        }
        
        //Audio player now ready
        
    }
}


struct readFile {
    static var arrayFloatValues:[Float] = []
    static var points:[CGFloat] = []
}
