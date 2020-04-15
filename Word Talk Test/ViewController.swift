//
//  ViewController.swift
//  Word Talk Test
//
//  Created by Jack Vaughn on 4/7/20.
//  Copyright © 2020 vaughn0523. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    private var whatYouSay = String()
    
    @IBOutlet weak var wordLabel: UILabel!
    
    var defaults = UserDefaults.standard
    
    lazy var words = defaults.object(forKey: "words") as? [String] ?? [String]()
    
    var wordCount = 0
    
    var isQueueRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if words.count == 0 {
            wordLabel.text = "a"
        } else {
            wordLabel.text = words[0]
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            if words.count == 0 {
                words = ["a", "the", "car"]
                defaults.set(words, forKey: "words")
            } else {
                words = defaults.object(forKey: "words") as! [String]
        }
            wordLabel.text = words[wordCount]
        requestPermission()
        do {
            try startRecording()
            print("Listening....")
        }
        catch {
            print("Oh no")
        }
    }
    
    
    func requestPermission() {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in

            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    print("Authorized")
                    
                case .denied:
                    print("Denied")
                    
                case .restricted:
                    print("Restricted")
                    
                case .notDetermined:
                    print("Not Determined")
                    
                default:
                    print("Default")
                }
            }
        }
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        self.speechRecognizer.defaultTaskHint = .dictation
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                isFinal = result.isFinal
                self.whatYouSay = result.bestTranscription.formattedString
                print("Text \(self.whatYouSay)")
                var isQueueEmpty: Bool
                var dispatchGroup = DispatchGroup.init()
                if !self.isQueueRunning {
                    self.check()
                }
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
            }
        }

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func check() {
        let wordsYouSay = whatYouSay.split(separator: " ").map {String($0)}
        let lowerWords = wordsYouSay.map { $0.lowercased()}
        if lowerWords.contains(wordLabel!.text!.lowercased()) {
            print("Match")
            wordLabel.textColor = UIColor(red: 170/255.0, green: 242/255.0, blue: 85/255.0, alpha: 1)
            wordLabel.text = words[wordCount]
            let seconds = 1.0
            audioEngine.stop()
            recognitionRequest?.endAudio()
            isQueueRunning = true
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.wordCount += 1
                if self.wordCount == self.words.count {
                    self.wordCount = 0
                }
                self.wordLabel.text = self.words[self.wordCount]
                self.wordLabel.textColor = UIColor.white
                self.isQueueRunning = false

                do {
                    try self.startRecording()
                    print("Listening....")
                }
                catch {
                    print("Oh no")
                }
            }
        }
    }
    
}

//class SaveMyShit: NSObject, NSCoding {
//    let names : [String]
//
//    init(names:[String]) {
//        self.names = names
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(names, forKey: "names")
//    }
//
//    convenience required init?(coder: NSCoder) {
//        guard let names = coder.decodeObject(forKey: "names") as? [String] else {
//            return nil
//        }
//        self.init(names: names)
//    }
//}
//
//class Util {
//    func storeCustomObjectToUserDefault(names: [String]) {
//        let data = try NSKeyedArchiver.archivedData(withRootObject: names, requiringSecureCoding: false)
//        UserDefaults.standard.set(data, forKey: "names")
//    }
//
//    func getCustomObjectFromUserDefault() -> [String]{
//        let data = UserDefaults.standard.value(forKey: "names")
//        let names = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSCoding.Protocol(SaveMyShit), from: data as! Data)
//        return names
//    }
//}
