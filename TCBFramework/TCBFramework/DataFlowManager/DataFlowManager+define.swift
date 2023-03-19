//
//  DataFlowManager+define.swift
//  TCB-Framework
//
//  Created by vinbigdata on 04/03/2023.
//

import Foundation
import UIKit


enum messageString:String {
    case canIHelpYou = "Tôi có thể giúp gì bạn"
    case watting = "Chờ chút nhé"
    case detailWatting = "Hệ thống đang xử lý. Bạn vui lòng chờ trong giây lát"
    case failed = "Dịch vụ tạm thời bị gián đoạn"
    case detailFailed = "Chúng tôi chưa thể xử lý yêu cầu của bạn. Vui lòng thử lại sau"
    case actionOK = "Tôi hiểu rồi"
    case suggest = "Vui lòng ra lệnh rõ hơn"
    case titleSuggest = "Gợi ý"
    case detailSugget = "Hãy nói \"Mở màn hình chuyển tiền\" hoặc \"Tôi muốn xem số dư tài khoản\" "
    case comingsoon = "Sắp ra mắt"
    case wakeUpWordGuide = "Bấm vào đây hoặc nói Hey \"ViVi\""
    case suggestPayObject = "Chuyển đến"
    case payNow = "Ngay lập tức"
    case sameDay = "Trong ngày"
    case detailComingsoon = "Tính năng này đang được triển khai. Bạn vui lòng thử lại sau"
    case screenLevel1 = "Tiết kiệm"
    case detailScreenLevel1 = "Gửi tiết kiệm, tích lũy, chứng chỉ tiền gửi"
    case clickOrSpeakWuw = "Bấm vào đây hoặc nói \"Hey ViVi\""
}



extension DataFlowManager {
    public static let waiting_timeout:TimeInterval = 3
    public static let fail_timeout:TimeInterval = 6
    
    public static func viviColor () -> UIColor {
        return.black
    }
}
