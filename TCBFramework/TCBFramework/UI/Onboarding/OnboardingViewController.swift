//
//  OnboardingViewController.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 19/07/2022.
//

import UIKit
import AVFAudio

class OnboardingViewController: UIViewController {

    @IBOutlet private weak var voiceAssistantView: VoiceAssistantView!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var leftLogoImageView: UIImageView!
    
    private let onboardTypes = OnboardingType.allCases
    private var audioPlayerOnboarding: AVAudioPlayer!
    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onRequestPermission),
                                               name: AIBankNotification.requestRecordPermission.name,
                                               object: nil)
        AppUserDefaults.shared.didShowOnboarding = true
        collectionView.register(OnboardingCollectionViewCell.self)
        collectionView.register(OnboardingFinalCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        audioPlayerOnboarding = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction private func skipButtonTapped(_ sender: UIButton) {
        // tutm cmt
        //AppDelegate.shared()?.setRootNavi(with: OnboardingFinalViewController())
    }
    
    @objc func onRequestPermission() {
        collectionView.reloadData { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let firstOnboarding = self?.onboardTypes.first {
                    self?.playOnboarding(onboardingType: firstOnboarding)
                }
            }
        }
    }
    
    private func playOnboarding(onboardingType: OnboardingType) {
        if let url = onboardingType.mp3File {
            do {
                Log.debug(message: "========= start play")
                audioPlayerOnboarding = try AVAudioPlayer(contentsOf: url)
                audioPlayerOnboarding.prepareToPlay()
                audioPlayerOnboarding.play()
                audioPlayerOnboarding.delegate = self
                voiceAssistantView.startAnimation(state: .speaking)
            } catch let error as NSError {
                Log.debug(message: "========= " + error.localizedDescription)
            } catch {
            }
        }
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch onboardTypes[indexPath.row] {
        case .fourth:
            let cell = collectionView.dequeue(OnboardingFinalCollectionViewCell.self, indexPath)
            return cell
        default:
            let cell = collectionView.dequeue(OnboardingCollectionViewCell.self, indexPath)
            cell.setupCell(onboardingType: onboardTypes[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            if currentIndex != indexPath.row {
                currentIndex = indexPath.row
                leftLogoImageView.isHidden = onboardTypes[indexPath.row] == .fourth
                skipButton.isHidden = onboardTypes[indexPath.row] == .fourth
                playOnboarding(onboardingType: onboardTypes[indexPath.row])
            }
        }
    }
}

extension OnboardingViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if currentIndex >= onboardTypes.count - 1 {
            return
        } else {
            currentIndex += 1
            collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .right, animated: true)
            playOnboarding(onboardingType: onboardTypes[currentIndex])
            leftLogoImageView.isHidden = onboardTypes[currentIndex] == .fourth
            skipButton.isHidden = onboardTypes[currentIndex] == .fourth
        }
    }
}
