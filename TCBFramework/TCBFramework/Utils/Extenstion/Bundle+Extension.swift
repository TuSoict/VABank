//
//  Bundle+Extension.swift
//  LocalFramworkWithPod
//
//  Created by nguyen.tuan.hai on 10/07/2022.
//

import Foundation

struct Resouces {
    static func getHeyVinHomeFile(vinhomeBundleFile: VinHomeBundleFile) -> String {
        return (Constants.appBundle.path(forResource: BundlePath.heyVinhome.rawValue, ofType: "bundle") ?? "") + "/\(vinhomeBundleFile.rawValue)"
    }
    
    static func getLottieFile(lottieBundleFile: LottieBundleFile) -> String {
        return (Constants.appBundle.path(forResource: BundlePath.lottieAnimation.rawValue, ofType: "bundle") ?? "") + "/\(lottieBundleFile.rawValue)"
    }
    
    static func getMP3File(mp3BundleFile: MP3FBundleFile) -> URL? {
        if let path = Constants.appBundle.path(forResource: BundlePath.mp3Files.rawValue, ofType: "bundle"),
           let bundle = Bundle(path: path),
           let url = bundle.url(forResource: mp3BundleFile.rawValue, withExtension: mp3BundleFile.extensionFile) {
            return url
        }
        return nil
    }
    
    static func getImageFile(imageBundleFile: ImagesBundleFile) -> String {
        return (Constants.appBundle.path(forResource: BundlePath.images.rawValue, ofType: "bundle") ?? "") + "/\(imageBundleFile.rawValue)"
    }
    
    static func getLocalFile(name:String, fileType:String) -> String {
        return (Constants.appBundle.path(forResource:name, ofType:fileType)! )
    }
}

enum BundlePath: String {
    case lottieAnimation = "lottie_animation"
    case heyVinhome = "hey_vivi"
    case fonts = "fonts"
    case mp3Files = "mp3_files"
    case images = "images"
}

enum VinHomeBundleFile: String {
    case data
    case info
}

enum LottieBundleFile: String {
    case IDLE
    case LISTENING
    case SPEAKING
    case THINKING
}

enum MP3FBundleFile: String {
    
    case noNetwork = "no_network"
    case tingWakeup = "ting_wakeup"
    case onboarding1 = "Onb_1"
    case onboarding2 = "Onb_2"
    case onboarding3 = "Onb_3"
    case onboarding4 = "Onb_4"

    var extensionFile: String {
        switch self {
        case .tingWakeup:
            return "wav"
        default:
            return "mp3"
        }
    }
}

enum ImagesBundleFile: String {
    case iconVoice = "ic_voice_speaking"
    case iconClose = "ic_close"
    case iconEarth = "ic_earth"
    case iconKeyboard = "ic_keyboard"
    case iconSend = "ic_send"
    case icPlay = "ic_play"
    case icVoice = "ic_voice"
    case icCircle = "ic_circle"
    case systemErrorImage = "ic_system_error"
    case icElectronic = "ic_electronic"
    case icWater = "ic_water"
    case iconChatHistory = "ic_chat_history"
    case iconVoiceOnKeyboard = "ic_voice_on_keyboard"
    case icProcessing = "ic_processing"
    case icFailed = "ic_failed"
    case icSuggest = "ic_suggest"
    case icComingsoon = "ic_comingsoon"
    case icScreenLevel1 = "ic_screen_level_1"
    case icTransfer = "ic_transfer"
    case icExits = "ic_exits"
case icArrowBack = "ic_arrow_back"
case icATM = "ic_atm"

    case icPayBill = "ic_pay_bill"
    case icAddress = "ic_address"
    case icStatement = "ic_statement"
    case icTechcombank = "Techcombank"
    case icAgribank = "Agribank"
    case icBIDV = "BIDV"
    case icVietcombank = "Vietcombank"
    case icVietinBank = "VietinBank"
    case icACB = "ACB"
    case icCAKE = "icCAKE"
    case icHSBC = "icHSBC"
    case icMB = "MB"
    case icMSB = "MSB"
    case icSCB = "SCB"
    case icSHB = "SHB"
    case icOceanBank = "OceanBank"
    case icSacombank = "Sacombank"
    case icSeaBank = "SeaBank"
    case icTPBank = "TPBank"
    case icVIB = "VIB"
    case icVPBank = "VPBank"
}
