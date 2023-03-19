//
//  BankAssistantDataSource.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

enum UserBehaviorEvent {
    case selectedBank(bank:Banks)
}

enum UserActionEvent {
    case SuggestionSelected(actionData:[String:String])
    case RetryVA
    case BankSelected(bank:Banks)
}

struct SectionData {
    var header: String?
    var items: [Any]
    var extraData : AnyObject?
    
    init(header: String? = nil, items: [Any] = []) {
        self.header = header
        self.items = items
    }
    
    init(item: Any) {
        self.items = [item]
    }
}

class BankAssistantDataSource: BaseDataSource {
    
    let subject = PublishSubject<UserActionEvent>()

    var datas: [SectionData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var willSendOTP: ((String) -> ())?
    
    private var message: BotMessage?
    
    func setMessage(_ message: BotMessage) {
        datas = message.dataSource
        self.message = message
    }
}

extension BankAssistantDataSource {
    private func getData(_ indexPath: IndexPath) -> Any? {
        return datas
            .safeValue(at: indexPath.section)?.items
            .safeValue(at: indexPath.row)
    }
}

extension BankAssistantDataSource: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return datas.safeValue(at: section)?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = getData(indexPath) else { return UITableViewCell() }
        
        let cellType: BaseTableViewCell.Type
        
        switch message?.command {
        case .stateSuggest, .stateComingsoon, .stateDefaulSuggest, .stateVAHome:
            cellType = SuggestionCell.self
        case .payBankObject:
            cellType = BankTableViewCell.self
        case .payAccountNumber:
            cellType = BankTransferTableViewCell.self
        case .payConfirm:
            cellType = MoneyTransferCell.self
        case .payPin:
            cellType = OTPCell.self
        case .stateScreenLevel1:
            cellType = SavingTableViewCell.self
        case .stateScreenError:
            cellType = ErrorViewCell.self
        default:
            return UITableViewCell()
        }
        return cellFor(type: cellType, data: data, tableView: tableView,indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {

        let label = UILabel().apply {
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = Colors.black
            $0.text = datas.safeValue(at: section)?.header
        }

        let spacer = UIView().apply {
            $0.set(width: 16)
        }

        return UIStackView().apply {
            $0.addArrangedSubviews([spacer, label])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if datas.safeValue(at: section)?.header == nil {
            return .leastNonzeroMagnitude
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch message?.command {
        case .stateVAHome, .stateSuggest, .stateComingsoon, .stateDefaulSuggest:
            return SuggestionCell.heightForRow()
        case .payBankObject:
            return BankTableViewCell.heightForRow()
        case .payConfirm:
            return MoneyTransferCell.heightForRow()
        case .stateScreenLevel1:
            return 80
        case .payPin:
            return OTPCell.heightForRow()
        case .stateScreenError:
            return ErrorViewCell.heightForRow()
        case .payAccountNumber:
            return BankTransferTableViewCell.heightForRow()
        default:
            return 0
        }
    }
    
    //MARK UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = getData(indexPath) else { return  }
        
        switch message?.command {
        case .stateSuggest, .stateComingsoon, .stateDefaulSuggest, .stateScreenLevel1, .stateVAHome:
            let suggestDataDict = data as! [String:String]
            self.subject.onNext(.SuggestionSelected(actionData: suggestDataDict))
            break
            
        case .payBankObject:
            let bank = data as! Banks
            self.subject.onNext(.BankSelected(bank: bank))
            break
            
        default:
            break
        }
    }
}

extension BankAssistantDataSource {
    private func cellFor<T: BaseTableViewCell>(type: T.Type,
                                             data: Any,
                                             tableView: UITableView,
                                               indexPath: IndexPath
    ) -> BaseTableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier:type.className,for: indexPath) as! BaseTableViewCell
        tableViewCell.set(data)
        
        if type == ErrorViewCell.self {
            let errorViewCell = tableViewCell as! ErrorViewCell
            errorViewCell.onBackVAHome = { [unowned self] in
                // back VA Home
                self.subject.onNext(.RetryVA)
            }
            
            return errorViewCell
        }
        
        return tableViewCell
    }
}
