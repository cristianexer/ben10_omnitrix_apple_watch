//
//  InterfaceController.swift
//  Omnitrix WatchKit Extension
//
//  Created by Cristian Fat on 12/21/19.
//  Copyright © 2019 Cristian Fat. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation


class InterfaceController: WKInterfaceController, WKCrownDelegate {


    @IBOutlet var group: WKInterfaceGroup!
    @IBOutlet var inner_image: WKInterfaceImage!
    var crownAccumulator:Double = 0.0;
    var acc:Int = 0;
    var omnitrix_open:Bool = false;
    let fm = FileManager()
    var aliens = [String]();
    let aliens_masks_path:String = "omni_aliens_masks2";
    let aliens_path:String = "aliens";
    var omni_taps:Int = 0;
    var alien_not_picked:Bool = true;
    var player: AVAudioPlayer!;
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        crownSequencer.delegate = self
        self.player = AVAudioPlayer()
        // Configure interface objects here.
        
        
        self.loadAliens()
        
    }
    
    func loadAliens() {
        let f = Bundle.main.url(forResource: self.aliens_path, withExtension: nil)!
        
        let al =  try! self.fm.contentsOfDirectory(at: f, includingPropertiesForKeys: nil, options: [])
        
        for alien in al{
            self.aliens.append(alien.lastPathComponent)
        }
    }
    
    
    func getImage(imageName : String,folder:String)-> UIImage{
        
        let f = Bundle.main.url(forResource: folder, withExtension: nil)!.appendingPathComponent(imageName).path
        
        return UIImage(contentsOfFile: f)!
            
    }
    
    func getSound(soundName : String)-> URL{
           
        return Bundle.main.url(forResource: "sounds", withExtension: nil)!.appendingPathComponent(soundName)
               
       }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        crownSequencer.focus()
        self.inner_image.setHidden(true)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    func activateOmnitrix(){
        group.setBackgroundImage(UIImage(named: "alien_picker"))
        self.omnitrix_open = true;
        self.inner_image.setImage(self.getImage(imageName: "mask_" + self.aliens[0], folder: self.aliens_masks_path))
        
        self.inner_image.setHidden(false);
        
        self.play(url:self.getSound(soundName: "open.mp3"))
    }
    
    func play(url:URL) {

        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            print("AVAudioPlayer init failed")
        }

    }
    
    func deactivateOmnitrix(){
        group.setBackgroundImage(UIImage(named: "omnitrix"))
        self.omnitrix_open = false;
        self.inner_image.setImage(self.getImage(imageName: "mask_" + self.aliens[0], folder: self.aliens_masks_path))
        
        self.inner_image.setHidden(true);
        
    }

    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        if(self.omnitrix_open && self.alien_not_picked){
            crownAccumulator += rotationalDelta
         if crownAccumulator > 0.1 {
            
            if(self.acc < self.aliens.count-1){
                self.acc += 1
                crownAccumulator = 0.0
            }else{
                self.acc = self.aliens.count-1
            }
            
            
         } else if crownAccumulator < -0.1 {
            
            if (self.acc > 0){
                self.acc -= 1;
                crownAccumulator = 0.0
            }
            else{
                self.acc=0;
            }
            
            
         }
            self.inner_image.setImage(self.getImage(imageName: "mask_" + self.aliens[self.acc], folder: self.aliens_masks_path))
            
            self.play(url:self.getSound(soundName: "switch_alien.wav"))
      }
    }
    
    @IBAction func tapOmnitrix(_ sender: Any) {
        activateOmnitrix()
    }
    
    @IBAction func tapAlien(_ sender: Any) {
        if self.omni_taps == 0{
        self.inner_image.setImage(self.getImage(imageName: self.aliens[self.acc], folder: self.aliens_path))
        self.omni_taps = 1;
        self.alien_not_picked = false;
        self.play(url:self.getSound(soundName: "transform.wav"))
        }
        else if self.omni_taps == 1{
            self.omni_taps=0;
            self.deactivateOmnitrix();
            self.alien_not_picked = true;
            self.play(url:self.getSound(soundName: "open.mp3"))
        }
    
    }
}
