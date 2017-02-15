//
//  ViewController.swift
//  QuickPlay_V
//
//  Created by TTung on 2/14/17.
//  Copyright © 2017 TTung. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    
    @IBOutlet weak var lbl_timeLeft: UILabel!
    @IBOutlet weak var lbl_Duration: UILabel!
    @IBOutlet weak var sld_duration: UISlider!
    
    
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var sld_volume: UISlider!
    @IBOutlet weak var sw_repeat: UISwitch!
    
    
    @IBOutlet weak var btn_song1: UIButton!
    @IBOutlet weak var lbl_songName: UILabel!
    @IBOutlet weak var lbl_listSong: UILabel!
 

    
    var audio = AVAudioPlayer()
    var running = 1
    var timer: Timer!
    var list = ["music","music2","music3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addThumbImgForSlider()
           }

    
    @IBAction func action_play(_ sender: UIButton) {
        playPause()
    }
    
    @IBAction func sld_volume(_ sender: UISlider) {
        
        audio.volume = sender.value
    }
 
    
    @IBAction func sld_duration(_ sender: UISlider) {
        audio.currentTime = TimeInterval(Float(sender.value) * Float(audio.duration))
        
    }
    
    
    @IBAction func action_listSong(_ sender: UIButton) {
        lbl_listSong.isHidden = false
        listSong()
        
    }

    
    func playPause(){
       
        if running == 1 {
            
            btn_play.setImage(UIImage(named: "pause.png"), for: UIControlState.normal)
          
            let playSong = randomSong()
            
            lbl_songName.text = playSong
            lbl_songName.isHidden = false

            audio = try! AVAudioPlayer(contentsOf: URL (fileURLWithPath: Bundle.main.path(forResource: playSong, ofType: ".mp3")!))
            audio.delegate = self

            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeCurrent), userInfo: nil, repeats: true)
           
            audio.play()
            updateTimeCurrent()
            checkRepeat()

            audio.prepareToPlay()
            
            running = 2
        }
         else {
            audio.stop()
            timer.invalidate()
            btn_play.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
            running = 1
        }
    }
    
    func updateTimeCurrent(){
        let currentTime = Int(audio.currentTime)
        let timeLeft = Int(audio.duration) - Int(audio.currentTime)
        let minutesCr = currentTime / 60
        let secondsCr = currentTime - minutesCr * 60
        let minutesLeft = timeLeft / 60
        let secondsLeft = timeLeft - minutesLeft * 60
        
        self.lbl_timeLeft.text = String(format: "%02d:%02d", minutesCr, secondsCr)
        self.lbl_Duration.text = String(format: "%02d:%02d" , minutesLeft , secondsLeft)
        self.sld_duration.value = Float(audio.currentTime / audio.duration)
    }

    func addThumbImgForSlider(){
        sld_volume.setThumbImage(UIImage(named: "thumb.png"), for: .normal)
        sld_volume.setThumbImage(UIImage(named:
         "thumbHightLight.png"), for: .highlighted)
    }
    
    func randomSong() -> String{
        let randomSong = Int(arc4random_uniform(UInt32(list.count)))
        let nameSong = list[randomSong]

        return nameSong
        
    }
    
    func listSong(){
        var fullList = ""
        for i in 0...list.count-1{
        fullList += "\(list[i])\n"
        }
        lbl_listSong.text = fullList
    }
    
    func checkRepeat(){
        if  sw_repeat.isOn {
            audio.numberOfLoops = -1
            updateTimeCurrent()
        }else{
            audio.numberOfLoops = 0
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        btn_play.setImage(UIImage(named: "play.png"), for: UIControlState.normal)

    }
    
}

