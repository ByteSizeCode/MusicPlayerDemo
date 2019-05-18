//
//  ViewController.swift
//  MusicPlayerDemo
//
//  Created by Isaac Raval on 5/17/19.
//  Copyright © 2019 Isaac Raval. All rights reserved.
//

import Foundation
import AppKit
import AudioToolbox
import AVFoundation
import Cocoa

let audioEngine: AVAudioEngine = AVAudioEngine()
let audioPlayer: AVAudioPlayerNode = AVAudioPlayerNode()
var songsInTableView:[NSTableCellView] = [NSTableCellView.init()]
var titleOfSongMostRecentlyPlayed = ""

class ViewController: NSViewController {
    
    //IBOutlets and properties
    @IBOutlet weak var tableView: NSTableView!
    var songNames = ["Royalty-Free1", "Royalty-Free2", "Royalty-Free3",
                     "Royalty-Free4", "Royalty-Free5", "Royalty-Free6"]
    let aud = MusicManager()
    var lastRowTapped = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

//Setup tableview
extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    //Number of rows in table view
    func numberOfRows(in tableView: NSTableView) -> Int {
        return songNames.count
    }
    
    //Add songs to table view as cells
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let song = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        song.textField?.stringValue = songNames[row] //Assign appropriate name from list of options to the cell based on its' index
        print("Adding \(songNames[row])")
        songsInTableView.append(song)
        
        return song
    }
}

//Implementation for row detection for this tableview
extension ViewController: NSTableViewClickableDelegate {
    @nonobjc func tableView(_ tableView: NSTableView, didClickRow row: Int) {
        print("Clicked row \(row)")
        
        //If user taps on song a second time, pause it
        if(row == lastRowTapped) {
            audioPlayer.pause()
            print("Pausing")
            songsInTableView[row + 1].textField?.stringValue = titleOfSongMostRecentlyPlayed //Change text back to song title
            lastRowTapped = -1 //Reset
        }
        else {
            
            //The below line is fine for small data sets, but has a performance penalty for large data sets (O(n))- a more complex solution is needed. Ensures all other cells are correctly named by song title (removes any occurenced of "Playing...").
            for (i, element) in songsInTableView.enumerated() {element.textField?.stringValue = songNames[i - 1]}
            
            //Play appropriate song
            let songToPlay = songNames[row]
            aud.setup(forSong: songToPlay, withExtension: "mp3")
            audioPlayer.play()
            
            titleOfSongMostRecentlyPlayed = songsInTableView[row + 1].textField!.stringValue //Save song title for later use
            print("Playing...")
            songsInTableView[row + 1].textField?.stringValue = "Playing..." //Change title to indicate song is playing
            
            lastRowTapped = row //Save clicked row for later use
        }
    }
}

//Allow for row click detection
extension NSTableView {
    open override func mouseDown(with event: NSEvent) {
        let globalLocation = event.locationInWindow
        let localLocation = self.convert(globalLocation, to: nil)
        let clickedRow = self.row(at: localLocation)
        
        super.mouseDown(with: event)
        
        if (clickedRow > -1) {
            (self.delegate as? NSTableViewClickableDelegate)?.tableView(self, didClickRow: clickedRow)
        }
    }
}
protocol NSTableViewClickableDelegate: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, didClickRow row: Int)
}

