//
//  AudioPlayer.swift
//  LocalFramworkWithPod
//
//  Created by Gà Nguy Hiểm on 30/06/2022.
//

import Foundation
import AVFAudio
import AVFoundation
import Alamofire

final class AudioPlayer: NSObject {
    static let shared = AudioPlayer()
    
    private var audioPlayer: AVAudioPlayer!
    private var audioPlayerSE: AVAudioPlayer!

    private var urls: [URL] = [] {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.startDownloadFile(index: 0, loadingId: self.loadingId)
            }
        }
    }
    
    private var onFinish: (() -> Void)?
    
    private var loadingId: Double = 0
    private var voiceDatas: [Data] = []
    
    private var playingIndex: Int = -1 {
        didSet {
            guard playingIndex >= 0, playingIndex < voiceDatas.count, loadingId != 0 else {
                return
            }
            startPlay(data: voiceDatas[playingIndex])
        }
    }
    
    func playAudio(urls: [URL], onFinish: (() -> Void)?) {
        guard !urls.isEmpty else { return }
        self.onFinish = onFinish
        playingIndex = -1
        self.loadingId = Date().timeIntervalSince1970
        self.voiceDatas = []
        self.urls = urls
    }
    
    func playNoNetwork() {
        self.onFinish = nil
        guard let url = Resouces.getMP3File(mp3BundleFile: .noNetwork),
              let data = try? Data(contentsOf: url) else { return }
        startPlay(data: data)
    }
    
    private func startDownloadFile(index: Int, loadingId: Double) {
        guard urls.count > index else { return }
        let url = urls[index]
        Log.debug(message: "=========== start download \(url)")
        
        AF.download(url).responseData { [weak self] response in
            guard let `self` = self else { return }
            switch response.result {
            case .success(let data):
                self.voiceDatas.append(data)
                if self.voiceDatas.count == 1 {
                    self.playingIndex = 0
                } else if false == self.audioPlayer?.isPlaying {
                    let temp = self.playingIndex
                    self.playingIndex = temp
                }
                if loadingId == self.loadingId {
                    self.startDownloadFile(index: index + 1, loadingId: loadingId)
                }
            case .failure(let error):
                Log.debug(message: "=========== download error \(error.localizedDescription)")
            }
        }
//        var downloadTask:URLSessionDownloadTask
//        downloadTask = URLSession.shared
//            .downloadTask(with: url, completionHandler: { [weak self] (localUrl, _, _) in
//                guard let `self` = self else { return }
//                if let url = localUrl,
//                   let data = try? Data(contentsOf: url) {
//                    self.voiceDatas.append(data)
//                }
//                if self.voiceDatas.count == 1 {
//                    self.playingIndex = 0
//                } else if false == self.audioPlayer?.isPlaying {
//                    let temp = self.playingIndex
//                    self.playingIndex = temp
//                }
//                if loadingId == self.loadingId {
//                    self.startDownloadFile(index: index + 1, loadingId: loadingId)
//                }
//            })
//        downloadTask.resume()
    }
    
    private func startPlay(data: Data) {
        do {
            Log.debug(message: "========= start play")
            self.audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.mp3.rawValue)//AVAudioPlayer(data: data)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            self.audioPlayer.delegate = self
        } catch let error as NSError {
            Log.debug(message: "========= play fail \(data)" + error.localizedDescription)
            playingIndex += 1
        } catch {
            playingIndex += 1
        }
    }
    
    func playSoundEffectWakeup() {
        if let url = Resouces.getMP3File(mp3BundleFile: .tingWakeup) {
            do {
                Log.debug(message: "========= start play")
                audioPlayerSE = try AVAudioPlayer(contentsOf: url)
                audioPlayerSE.prepareToPlay()
                audioPlayerSE.play()
                audioPlayerSE.delegate = self
            } catch let error as NSError {
                Log.debug(message: "========= " + error.localizedDescription)
            } catch {
            }
        }
    }
    
    func pause() {
        self.audioPlayer.pause()
    }
    
    func remove() {
        Log.debug(message: "=============== audio remove")
        loadingId = 0
        onFinish = nil
        if audioPlayer != nil && audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayer = nil
        }
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == audioPlayerSE {
            audioPlayerSE = nil
        } else {
            self.playingIndex += 1
            if playingIndex >= urls.count {
                onFinish?()
            }
            Log.debug(message: "=============== audio finish \(flag)")
        }
    }
}
