//
//  OnboardingCollectionViewCell.swift
//  BankAssistant
//
//  Created by nguyen.tuan.hai on 19/07/2022.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var onboardingTitleLabel: UILabel!
    @IBOutlet weak var onboardingDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(onboardingType: OnboardingType) {
        onboardingImageView.image = onboardingType.image
        onboardingTitleLabel.text = onboardingType.title
        onboardingDescriptionLabel.text = onboardingType.description
    }
}

enum OnboardingType: CaseIterable {
    
    case first
    case second
    case third
    case fourth
    
    var image: UIImage {
        switch self {
        case .first:
            return #imageLiteral(resourceName: "onboarding_1")
        case .second:
            return #imageLiteral(resourceName: "onboarding_2")
        case .third:
            return #imageLiteral(resourceName: "onboarding_3")
        default:
            return UIImage()
        }
    }
    
    var title: String {
        switch self {
        case .first:
            return "Nạp tiền & Rút tiền"
        case .second:
            return "Thanh toán dễ dàng"
        case .third:
            return "Mua sắm Online"
        case .fourth:
            return ""
        }
    }
    
    var description: String {
        switch self {
        case .first:
            return "Nạp tiền mọi lúc, rút tiền mọi nơi không\ngiới hạn qua AI Bank"
        case .second:
            return "Không lo nợ cước. Chạm ngay, thanh\ntoán liền tay hóa đơn điện, nước, ..."
        case .third:
            return "Tiết kiệm thời gian, thanh toán dễ dàng,\ngiao hàng tận nơi. Mua sắm online\nchưa bao giờ đơn giản hơn với AI Bank"
        case .fourth:
            return ""
        }
    }
    
    var mp3File: URL? {
        switch self {
        case .first:
            return Resouces.getMP3File(mp3BundleFile: .onboarding1)
        case .second:
            return Resouces.getMP3File(mp3BundleFile: .onboarding2)
        case .third:
            return Resouces.getMP3File(mp3BundleFile: .onboarding3)
        case .fourth:
            return Resouces.getMP3File(mp3BundleFile: .onboarding4)
        }
    }
}
