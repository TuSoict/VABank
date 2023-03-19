//
//  MessageModel.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation
//import WakeupWord
import ObjectMapper


enum Command: String, CaseIterable {
    case greeting = "GREETING"
    case login = "SCR_QNA_APP_LOGIN"
    case fallBack = "FALLBACK"
    case forgotPassword = "PASSWORDS_FORGET"
    
    case loan = "ADVISOR_AUTO_LOAN"
    case loanAmount = "ADVISOR_AUTO_LOAN_AMOUNT"
    case loanPeriod = "ADVISOR_LOAN_PERIOD"
    case loanMethod = "ADVISOR_LOAN_METHOD"
    
    case feedBack = "FEEDBACK_CONFIRM"
    case feedBackSuccess = "FEEDBACK_SUCCESS"
    
    case ewbilling = "CHECKING_UTILITIES_EXPENSE_TYPE"
    case eBillLastMonth = "CHECKING_ELECTRICITY_EXPENSE_LAST_MONTH"
    case eBillCurrent = "CHECKING_ELECTRICITY_EXPENSE_THIS_MONTH"
    case eBillByMonth = "CHECKING_ELECTRICITY_EXPENSE_Y_MONTH"
    
    case wBillLastMonth = "CHECKING_WATER_EXPENSE_LAST_MONTH"
    case wBillCurrent = "CHECKING_WATER_EXPENSE_THIS_MONTH"
    case wBillByMonth = "CHECKING_WATER_EXPENSE_Y_MONTH"
    
    case transactionList = "CHECKING_TRANSACTION_LIST"
    case latestTransaction = "CHECKING_LATEST_TRANSACTION"
    case transactionByTime = "CHECKING_TRANSACTION_DATETIME"
    
    case moneyTransfer = "TRANSFER_MONEY_A_CONFIRM"
    case otp = "VERIFY_OTP"
    case otpConfirm = "VERIFY_OTP_CONFIRMED"
    case moneyTransferDone = "TRANSFER_SUCCESS"
    case moneyTransferSuccess = "TRANSFER_MONEY_A_SUCCESS"
    
    case bankTransfer = "TRANSFER_RECEIVER_ACCOUNT_INFOR"
    case bankTransferAccount = "TRANSFER_RECEIVER_ACCOUNT_MONEY"
    case bankTransferConfirm = "TRANSFER_CONFIRM"
    
    case lockingCards = "LOCKING_CARDS_TYPE"
    case lockVisaCard = "LOCKING_CARDS_VISA"
    case lockMasterCard = "LOCKING_CARDS_MASTER"
    case lockCardSuccess = "LOCKING_CARDS_SUCCESS"
    
    case paymentElectricBill = "PAYMENT_ELECTRICITY_EXPENSE_CONFIRM"
    case paymentWaterBill = "PAYMENT_WATER_EXPENSE_CONFIRM"
    
    case paymentEWSuccess = "PAYMENT_EXPENSE_SUCCESS"
    
    case chargePhone = "PREPAID_CONFIRM"
    case chargeSuccess = "PREPAID_SUCCESS"
    
    case balance = "CHECKING_ACCOUNT_BALANCE"
    case minimumBalance = "SAVING_ACCOUNT_MINIMUM_AMOUNT"
    case atmDirection = "ATM_DIRECTION"
    case bankDirection = "BANKING_OFFICE_DIRECTION"
    case atmLocation = "ATM_LOCATION"
    case atmDirectionAddress = "ATM_DIRECTION_ADDRESS"
    case bankLocation = "BANKING_OFFICE_LOCATION"
    case bankLocationAddress = "BANKING_OFFICE_LOCATION_ADDRESS"
    
    case ratingTable = "SAVING_ACCOUNT_INTEREST_RATE"
    case ratingInMonth = "SAVING_ACCOUNT_RATE_X_MONTH"
    case ratingInMonthVND = "SAVING_ACCOUNT_RATE_VND"
    case ratingInMonthUSD = "SAVING_ACCOUNT_RATE_USD"
    
    case stateVAHome = "VA_HOME"
    case stateSuggest = "SCREEN_SUGGEST"
    case stateDeeplink = "SCREEN_DETAIL_DEEPLINK"
    case stateScreenLevel1 = "SCREEN_LEVEL_1"
    case stateComingsoon = "SCREEN_COMING_SOON"
    
    case payBankObject = "PAY_BANK_OBJECT"
    case payAccountNumber = "PAY_ACCOUNT_NUMBER"
    case payMoney = "PAY_MONEY"
    case payBalanceOut = "PAY_BALANCE_OUT"
    case payConfirm = "PAY_CONFIRM"
    case payPin = "PAY_PIN"
    case payPinType = "PAY_PIN_TYPE"
    case payPinRetype = "PAY_PIN_RETYPE"
    case paySucess = "PAY_SUCCESS"
    
    //local COMMAND
    case payBankSelect = "PAY_BANK_SELECT"
    case stateDefaulSuggest = "SCREEN_SUGGEST_DEFAULT"
    case stateScreenError = "SCREEN_ERROR"

}

enum Velocity: String, CaseIterable {
    case immediate = "IMMEDIATE"
    case continuous = "CONTINOUS"
}

enum ButtonAction:String,CaseIterable {
    case postBack = "postback"
    case link = "link"
}

extension BotMessage {
    
    var command: Command? {
        return Command.allCases
            .first(where: { elements.contains($0.rawValue) })
    }

    var isNextListening: Bool {
        return elements.contains("LISTENING")
    }
    
    var isContinious: Bool {
        #if DEBUG
        return false
        #endif
        return elements.contains(Velocity.continuous.rawValue)
    }
    
    var elements: [String] {
        return value.stringValue()
            .replacingOccurrences(of: "_command:", with: "")
            .components(separatedBy: "|")
    }
    
    var commandMessage: String {
        return elements.safeValue(at: 2).stringValue()
    }
    
    var messageObject: Any? {
        guard let jsonData = value?.toJSON() as? [String: Any] else {
            return nil
        }
        return jsonData
    }
    
    
    static func generateBotMessageValue(cmd: Command,velocity:Velocity, data:String) -> String {
        return "_command:DISPLAY|" + velocity.rawValue   + "|" + cmd.rawValue + "|data=" + data
    }

    
    var dataSource: [SectionData] {
        switch command {
        case .ratingInMonth:
            return [SectionData(item: Rating(vnd: elements.last.stringValue(), usd: elements.last.stringValue()))]
        case .ratingInMonthUSD:
            return [SectionData(item: Rating(vnd: nil, usd: elements.last.stringValue()))]
        case .ratingInMonthVND:
            return [SectionData(item: Rating(vnd: elements.last.stringValue(), usd: nil))]
            
        case .feedBack, .bankTransferAccount, .lockCardSuccess,
                .paymentEWSuccess, .moneyTransferDone, .chargePhone, .moneyTransferSuccess, .bankTransferConfirm:
            
            return [SectionData(item: elements.last.stringValue())]
        case .otp:
            return [SectionData(item: "")]
        case .otpConfirm:
            return [SectionData(item: "1234")]
            
        case .feedBackSuccess:
            return [SectionData(item: "Gửi phản hồi thành công")]
            
        case .atmDirection, .atmDirectionAddress:
            return [SectionData(item: "atm_direction")]
        case .bankDirection:
            return [SectionData(item: "office_direction")]
        case .bankLocation, .bankLocationAddress:
            return [SectionData(item: "bank_location")]
        case .atmLocation:
            return [SectionData(item: "atm_location")]
        case .ratingTable:
            return [SectionData(item: "rate_table")]
            
        case .paymentWaterBill, .paymentElectricBill:
            let date = Date().toString(format: "MM/yyyy")
            let item = EWBilling(type: command == .paymentElectricBill ? .electric : .water,
                                 date: date,
                                 code: command == .eBillCurrent ? "PD123456789101" : "12686868",
                                 name: "Phạm Văn Cường",
                                 money: command == .paymentElectricBill ? "VND 453,799" : "VND 200,000")
            return [SectionData(item: item)]
            
        case .loan:
            let items = [
                Loan(avatar: "ic_money", title: "Hạn mức gói vay", subTitle: "80% giá trị xe"),
                Loan(avatar: "ic_chart", title: "Lãi suất thấp nhất", subTitle: "Từ 7,3 % / năm"),
                Loan(avatar: "ic_piggy_bank", title: "Thời gian gói vay", subTitle: "Lên đến 96 tháng"),
                Loan(avatar: "ic_calendar", title: "Thời gian xử lý hồ sơ", subTitle: "8 giờ làm việc")
            ]
            return [SectionData(header: nil, items: items)]
        case .loanAmount:
            return [SectionData(item: LoanDetail())]
        case .loanPeriod:
            return [SectionData(item: LoanDetail(amount: elements.last.stringValue()))]
        case .loanMethod:
            let bePaid = elements.getLast(offset: 2).stringValue().components(separatedBy: " ").last
            
            return [SectionData(item: LoanDetail(bePaid: bePaid.stringValue(),
                amount: elements.getLast(offset: 1).stringValue(),
                                                 period: elements.last.stringValue()))]
        case .eBillLastMonth, .wBillLastMonth:
            let money = value.stringValue().components(separatedBy: " ").getLast(offset: 1)
            let date = Date().monthByAdding(value: -1)?.toString(format: "MM/yyyy")
            let item = EWBilling(type:  command == .eBillLastMonth ? .electric : .water,
                                 date: date.stringValue(),
                                 code: command == .eBillLastMonth ? "PD123456789101" : "12686868",
                                 name: "Phạm Văn Cường",
                                 money: money.stringValue())
            return [SectionData(item: item)]
        case .eBillByMonth, .wBillByMonth:
            let component = value.stringValue().components(separatedBy: " ")
            let money = component.getLast(offset: 1)
            let month = component.first(where: {
                guard let value = Int($0) else { return false }
                return value > 0 && value <= 12
            })
            let item = EWBilling(type: command == .eBillByMonth ? .electric : .water,
                                 date: month.stringValue() + "/" + Date().toString(format: "yyyy"),
                                 code: command == .eBillByMonth ? "PD123456789101" : "12686868",
                                 name: "Phạm Văn Cường",
                                 money: money.stringValue())
            return [SectionData(item: item)]
        case .eBillCurrent, .wBillCurrent:
            let money = value.stringValue().components(separatedBy: " ").getLast(offset: 1)
            let date = Date().toString(format: "MM/yyyy")
            let item = EWBilling(type: command == .eBillCurrent ? .electric : .water,
                                 date: date,
                                 code: command == .eBillCurrent ? "PD123456789101" : "12686868",
                                 name: "Phạm Văn Cường",
                                 money: money.stringValue())
            return [SectionData(item: item)]
            
        case .transactionList:
            return toTransactionData()
        case .latestTransaction:
            return toRecentTransactionData()
        case .transactionByTime:
            return toTransactionDataOnDate()
            
        case .lockingCards:
            return toCards()
        case .lockVisaCard:
            return toLockVisa()
        case .lockMasterCard:
            return toLockMaster()
        case .payBankObject:
            return toBanks()
        case .payAccountNumber:
            return toSelectedBanks()
        case .payConfirm:
            return toDataObject()
        case .payPin:
            return toDataString()
        case .stateSuggest, .stateComingsoon, .stateVAHome, .stateDefaulSuggest:
            return toButtonDataSuggestion(header: messageString.titleSuggest.rawValue)
        case .stateScreenLevel1:
            return toButtonDataSuggestion(header: "")

        default:
            return [SectionData(item: "")]
    }
 }
}

struct TransactionData {
    var name: String = ""
    var time: String = ""
    var money: String = ""
    var avatar: String = ""
    var phone: String = ""
    var content: String = ""
    
    var isPlus: Bool = true
}

struct Loan {
    var avatar: String
    var title: String
    var subTitle: String
}

struct LoanDetail {
    var bePaid: String = ""
    var amount: String = ""
    var period: String = ""
}

struct Card {
    enum CardType: String {
        case visa = "Visa"
        case master = "Master"
        
        var image: String {
            switch self {
            case .visa:
                return "ic_visa_card"
            case .master:
                return "ic_master_card"
            }
        }
    }

    var money: String
    var type: CardType
    
    var isLock = false
}

struct EWBilling {
    enum BillType {
        case electric
        case water
    }
    var type: BillType
    var date: String
    var code: String
    var name: String
    var money: String
}

struct Rating {
    var vnd: String?
    var usd: String?
}

extension BotMessage {
    private func toTransactionData() -> [SectionData] {
        let today: [TransactionData] = [
            TransactionData(name: "Shopping", time: "12:20", money: "535.000",
                            avatar: "ic_shopping", phone: "", content: "", isPlus: false),
            TransactionData(name: "Hiền trần", time: "11:30", money: "500.000",
                            avatar: "ic_avatar_hien", phone: "", content: "", isPlus: true)
        ]
        
        let yesterday = [
            TransactionData(name: "Phạm Cường", time: "08:23", money: "500.000",
                            avatar: "ic_avatar_cuong", phone: "", content: "", isPlus: true),
            TransactionData(name: "Bryan Pham", time: "11:30", money: "500.000",
                            avatar: "ic_avatar_hien", phone: "", content: "", isPlus: true),
            TransactionData(name: "Food", time: "05:12", money: "125.000",
                            avatar: "ic_food", phone: "", content: "", isPlus: false)
        ]
        
        let otherDay = [
            TransactionData(name: "Music", time: "18 may 09:43", money: "65.000",
                            avatar: "ic_music", phone: "", content: "", isPlus: false),
            TransactionData(name: "Food", time: "18 may 14:23", money: "43.000",
                            avatar: "ic_food", phone: "", content: "", isPlus: true),
            TransactionData(name: "Food", time: "05:12", money: "125.000",
                            avatar: "ic_food", phone: "", content: "", isPlus: false)
            
        ]
        
        return [
            SectionData(header: "Today", items: today),
            SectionData(header: "Yesterday", items: yesterday),
            SectionData(header: "18/5", items: otherDay),
        ]
    }
}

extension BotMessage {
    func toRecentTransactionData() -> [SectionData] {
        let item = TransactionData(name: "Hiền trần", time: "11:30",
                                   money: "500.000", avatar: "ic_avatar_hien",
                                   phone: "0123456789", content: "", isPlus: true)
        return [SectionData(item: item)]
    }
}

extension BotMessage {
    func toTransactionDataOnDate() -> [SectionData] {
        let items = [
            TransactionData(name: "Shopping", time: "12:20", money: "535.000",
                            avatar: "ic_shopping", phone: "", content: "", isPlus: false),
            TransactionData(name: "Hiền trần", time: "11:30", money: "500.000",
                            avatar: "ic_avatar_hien", phone: "", content: "", isPlus: true),
            TransactionData(name: "Music", time: "09:43", money: "65.000",
                            avatar: "ic_music", phone: "", content: "", isPlus: false),
            TransactionData(name: "Food", time: "08:23", money: "430.000",
                            avatar: "ic_food", phone: "", content: "", isPlus: false),
            TransactionData(name: "Medicine", time: "07:32", money: "43.000",
                            avatar: "ic_heart", phone: "", content: "", isPlus: true),
        ]
        
        return [SectionData(header: nil, items: items)]
    }
}

extension BotMessage {
    func toCards() -> [SectionData] {
        let items: [Card] = [
            Card(money: "VND 20.000.000", type: .visa),
            Card(money: "VND 35.000.000", type: .master)
        ]
        return [SectionData(header: "Danh sách thẻ", items: items)]
    }
    
    func toLockMaster() -> [SectionData] {
        let items: [Card] = [
            Card(money: "VND 20.000.000", type: .visa),
            Card(money: "VND 35.000.000", type: .master, isLock: true)
        ]
        return [SectionData(header: "Danh sách thẻ", items: items)]
    }
    
    func toLockVisa() -> [SectionData] {
        let items: [Card] = [
            Card(money: "VND 20.000.000", type: .visa, isLock: true),
            Card(money: "VND 35.000.000", type: .master)
        ]
        return [SectionData(header: "Danh sách thẻ", items: items)]
    }
    
    
    func toButtonDataSuggestion(header: String) -> [SectionData] {
        let dataString = self.elements.last.stringValue()
        let dataJson = dataString.replacingOccurrences(of: "data=", with: "")
        let dataDict = self.convertStringToDictionary(text: dataJson)
        
        let arrayData = dataDict!["buttons"]!
        var items: [Any] = []
        for value in arrayData as! [AnyObject] {
            items.append(value)
        }
        return [SectionData(header: header,items:items)]
    }
    
    func toBanks() -> [SectionData] {
        let banks = self.extraData as! TCBBanks
        var items: [Any] = []
        for value in banks.bank! {
            let bank = value as Banks
            items.append(bank)
        }
        return [SectionData(header:"", items:items)]
    }
    
    func toDataObject() -> [SectionData] {
        let dataString = self.elements.last.stringValue()
        let dataJson = dataString.replacingOccurrences(of: "data=", with: "")
        let dataDict = self.convertStringToDictionary(text: dataJson)
        
        var items: [Any] = []
        items.append(dataDict as Any)

        return [SectionData(header:"", items:items)]
    }
    
    func toDataString() -> [SectionData] {
        let dataString = self.elements.last.stringValue().replacingOccurrences(of: "data=", with: "")
        
        var items: [Any] = []
        items.append(dataString)

        return [SectionData(header:"", items: items)]
    }
    
    func toSelectedBanks() -> [SectionData] {
        let dataString = self.elements.last.stringValue()
        let dataJson = dataString.replacingOccurrences(of: "data=", with: "")
        let dataDict = self.convertStringToDictionary(text: dataJson)
        let bankName = dataDict!["bank_name"] as! String
        
        var items:[Banks] = [Banks]()
        if bankName.count > 0 {
            let bank = DataFlowManager.shared.banks?.bank!.filter({ $0.bid == bankName })
            if bank!.count > 0 {
                items.append((bank?.first)!)
            }
        }
        return [SectionData (header:messageString.suggestPayObject.rawValue,items: items)]
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                #if DEBUG
                print("Something went wrong")
                #endif
            }
        }
        return nil
    }
    
    
}
