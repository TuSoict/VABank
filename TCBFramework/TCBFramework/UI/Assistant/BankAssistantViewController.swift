//
//  BankAssistantViewController.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import UIKit

class BankAssistantViewController: BaseViewController {
    
    @IBOutlet weak var heightTitleLableContraints: NSLayoutConstraint!
    @IBOutlet var detailWaringLable: UILabel!
    @IBOutlet var warningLable: UILabel!
    @IBOutlet var stateImageView: UIImageView!
    @IBOutlet weak var navigationView: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var assistantView: VoiceAssistantView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var transcriptLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet var heightWarningViewContraints: NSLayoutConstraint!
    
    @IBOutlet var heightStateImageViewContraints: NSLayoutConstraint!
    
    init() {
        super.init(nibName: "BankAssistantViewController", bundle: Bundle(for: BankAssistantViewController.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var waveView = SiriWaveformView().apply {
        $0.waveColor = DataFlowManager.viviColor()
        $0.set(height: 40)
        $0.numberOfWaves = 3
        $0.backgroundColor = .clear
    }
    
    let viewModel = BankAssistantViewModel()
    
    private var dataSource: BankAssistantDataSource? {
        didSet {
            dataSource?.willSendOTP = { [weak self] pin in
                self?.viewModel.sendVoice(pin)
            }
            tableView.delegate = dataSource
            tableView.dataSource = dataSource
            tableView.contentInset.bottom = 120
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if DEBUG
        // viewModel.sendVoice("Chuyển tiền tới BIDV số tài khoản 123456 số tiền 1 triệu")
//        viewModel.sendVoice("Tôi muốn gửi tiết kiệm")
//        viewModel.sendVoice("Mở khoá thẻ ở đâu đó")
//        viewModel.sendVoice("Mở màn hình")
   //     viewModel.sendVoice("một hai ba bốn năm")
        #endif
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetData()
    }
    
    func loadViewFromNib() -> SuggestionCell {
    let bundle = Constants.appBundle
    let nib = UINib(nibName: "SuggestionCell", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! SuggestionCell
    return view
    }
   
    override func setupUI() {
        assistantView.startAnimation(state: .active)
        let bundle = Constants.appBundle;
        self.tableView.backgroundColor = .white
        
        tableView.apply {
            $0.register(UINib(nibName:SuggestionCell.className, bundle: bundle), forCellReuseIdentifier:SuggestionCell.className)
            $0.register(UINib(nibName:BankTableViewCell.className, bundle: bundle), forCellReuseIdentifier:BankTableViewCell.className)
            $0.register(UINib(nibName:MoneyTransferCell.className, bundle: bundle), forCellReuseIdentifier:MoneyTransferCell.className)
            $0.register(UINib(nibName:OTPCell.className, bundle: bundle), forCellReuseIdentifier:OTPCell.className)
            $0.register(UINib(nibName:SavingTableViewCell.className, bundle: bundle), forCellReuseIdentifier:SavingTableViewCell.className)
            $0.register(UINib(nibName:ErrorViewCell.className, bundle: bundle), forCellReuseIdentifier:ErrorViewCell.className)
            $0.register(UINib(nibName:BankTransferTableViewCell.className, bundle: bundle), forCellReuseIdentifier:BankTransferTableViewCell.className)
            
        }
        
        assistantView.startAnimation(state: Assistant.shared.state)
        
        let messageDefault = BotMessage(type: BotMessageType.text, value: "_command:DISPLAY|IMMEDIATE|SCREEN_SUGGEST_DEFAULT|data={\n  \"buttons\":[\n    {\n      \"title\": \"Chuyển tiền cho người thân\",\n      \"icon\": \"ic_transfer\",\n      \"type\": \"postback\",\n      \"value\": \"Chuyển tiền cho người thân\"\n    },\n    {\n      \"title\": \"Thanh toán hóa đơn\",\n      \"icon\": \"ic_pay_bill\",\n      \"type\": \"postback\",\n      \"value\": \"Thanh toán hóa đơn\"\n    },\n    {\n      \"title\": \"Rút tiền không cần thẻ\",\n      \"icon\": \"ic_atm\",\n      \"type\": \"postback\",\n      \"value\": \"Rút tiền không cần thẻ\"\n    },\n    {\n      \"title\": \"Xem lịch sử giao dịch\",\n      \"icon\": \"ic_statement\",\n      \"type\": \"postback\",\n      \"value\": \"Xem lịch sử giao dịch\"\n    } \n  ]\n  }")
        self.transcriptLabel.text = messageString.clickOrSpeakWuw.rawValue
        transcriptLabel.isHidden = false
        self.displayMessage(messageDefault)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func setupEvent() {
        navigationView.onBack = { [unowned self] in
            self.backAction()
        }
        
        Assistant.shared.event
            .subscribe(onNext: { [weak self] event in
                self?.handleEvent(event)
            })
            .disposed(by: disposeBag)
        
        assistantView.onTouch = {
            if Assistant.shared.state == .listening ||
                Assistant.shared.state == .waiting {
                self.viewModel.isNeedCancelCurrentThread = true
                //move to state VAhome
                self.assistantView.startAnimation(state: .active)
                
            } else {
                self.viewModel.isNeedCancelCurrentThread = false
                Assistant.shared.wakeup()
                DataFlowManager.shared.changeStateAssistant(state: .activeStateAssistant)
            }
        }
        
        viewModel.message.skip(1)
            .subscribe(onNext: { [weak self] message in
                self?.displayMessage(message)
            }).disposed(by: disposeBag)
        
    }
    
    override func backAction() {
        if (navigationView.isVAHome) {
            self.resetData()
            
            guard viewModel.message.value == nil else {
                return viewModel.message.accept(nil)
            }
            super.backAction()
        } else {
            let messageDefault = BotMessage(type: BotMessageType.text, value: "_command:DISPLAY|IMMEDIATE|SCREEN_SUGGEST_DEFAULT|data={\n  \"buttons\":[\n    {\n      \"title\": \"Chuyển tiền cho người thân\",\n      \"icon\": \"ic_transfer\",\n      \"type\": \"postback\",\n      \"value\": \"Chuyển tiền cho người thân\"\n    },\n    {\n      \"title\": \"Thanh toán hóa đơn\",\n      \"icon\": \"ic_pay_bill\",\n      \"type\": \"postback\",\n      \"value\": \"Thanh toán hóa đơn\"\n    },\n    {\n      \"title\": \"Rút tiền không cần thẻ\",\n      \"icon\": \"ic_atm\",\n      \"type\": \"postback\",\n      \"value\": \"Rút tiền không cần thẻ\"\n    },\n    {\n      \"title\": \"Xem lịch sử giao dịch\",\n      \"icon\": \"ic_statement\",\n      \"type\": \"postback\",\n      \"value\": \"Xem lịch sử giao dịch\"\n    } \n  ]\n  }")
            self.displayMessage(messageDefault)
        }
    }
    
    private var timer: Timer? {
        didSet {
            oldValue?.invalidate()
            if let timer: Timer = timer {
                RunLoop.main.add(timer, forMode: .common)
            }
        }
    }
    
    private var proccesingCheckTimer: Timer? {
        didSet {
            oldValue?.invalidate()
            if let timer: Timer = proccesingCheckTimer {
                RunLoop.main.add(timer, forMode: .common)
            }
        }
    }
    
    private var failCheckTimer: Timer? {
        didSet {
            oldValue?.invalidate()
            if let timer: Timer = failCheckTimer {
                RunLoop.main.add(timer, forMode: .common)
            }
        }
    }

}

extension BankAssistantViewController {
    private func handleEvent(_ event: AssistantEvent) {
        switch event {
        case .receiveTranscript(let message, let isFinal):
            if self.viewModel.isNeedCancelCurrentThread == false {
                if isFinal {
                    viewModel.sendVoice(message)
                    timer = nil
                    waveView.isHidden = true
                    
                    //start timer checking state
                    DataFlowManager.shared.changeStateAssistant(state: .activeStateAssistant)
                    self.startTimerCheckProcessing()
                    self.startTimerCheckFailer()
                }
            }
            transcriptLabel.text = message
        case .stateChanged(let state):
            assistantView.startAnimation(state: state)
            if state == .waiting {
                startTimer()
                waveView.isHidden = false
            } else {
                waveView.isHidden = true
            }
        case .onWakeup:
            guard viewModel.message.value?.isNextListening == false else {
//                voiceIndex = voiceIndex + 1
                return
            }
            viewModel.message.accept(nil)

        case .stateSocket:
            break
        }
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer(timeInterval: 0.5, target: self,
                      selector: #selector(checkSoundWave), userInfo: nil, repeats: true)
        waveView.isHidden = false
    }
    func startTimerCheckProcessing () {
        guard proccesingCheckTimer == nil else { return }
        proccesingCheckTimer = Timer(timeInterval:DataFlowManager.waiting_timeout, target: self,
                      selector: #selector(checkProcessingAssistant), userInfo: nil, repeats: true)
    }
    
    func startTimerCheckFailer () {
        guard failCheckTimer == nil else { return }
        failCheckTimer = Timer(timeInterval:DataFlowManager.fail_timeout, target: self,
                      selector: #selector(checkFailAssistant), userInfo: nil, repeats: true)
    }
    
    @objc
    func checkSoundWave() {
        waveView.updateWithLevel(level: Assistant.shared.averagePower)
    }
    
    @objc func checkProcessingAssistant() {
        if DataFlowManager.shared.stateOfAssistant == .activeStateAssistant {
            DataFlowManager.shared.changeStateAssistant(state: .processingStateAssistant)
            self.updateUI()
        }
    }
    
    @objc func checkFailAssistant() {
        if DataFlowManager.shared.stateOfAssistant == .processingStateAssistant {
            DataFlowManager.shared.changeStateAssistant(state: .failedStateAssistant)
            self.updateUI()
        }
    }
}

extension BankAssistantViewController {
    func setDataSource(_ message: BotMessage) {
        dataSource = BankAssistantDataSource(tableView: tableView)
        dataSource?.setMessage(message)
        dataSource?.subject
                .subscribe(onNext: { [weak self] value in
                    self?.handleUserActionEvent(value)
                }, onCompleted: {
                    // completed
                }).disposed(by: disposeBag)
    }
    
    private func handleUserActionEvent(_ event: UserActionEvent) {
        switch event {
        case .SuggestionSelected(let buttonAction):
            let type = buttonAction["type"]
            let value = buttonAction["value"]
            if (type!.count > 0 && (type?.compare(ButtonAction.postBack.rawValue, options: .caseInsensitive)) == ComparisonResult.orderedSame) {
                if(value!.count > 0) {
                self.viewModel.sendVoice(value!)
                }
            } else if ((type?.compare(ButtonAction.link.rawValue, options: .caseInsensitive)) == ComparisonResult.orderedSame) {
                self.openDeepLink(deepLink: value!)
            }
            break
            
        case .RetryVA:
            self.backAction()
            
        case .BankSelected(let bank):
            if bank.bid!.count > 0 {
                self.viewModel.sendVoice(bank.bid!)
            }
        }
        
    }
    
    private func displayMessage(_ message: BotMessage?) {
        messageLabel.isHidden = true
        transcriptLabel.text = messageString.clickOrSpeakWuw.rawValue
        self.tableView.isScrollEnabled = false
        
        var isVAHome = false
        guard var message = message else {
            dataSource = nil
            return
        }
        
        if message.isContinious == true {
            DataFlowManager.shared.changeStateViviVelocity(state: .continuous)
        } else {
            DataFlowManager.shared.changeStateViviVelocity(state: .immediate)
        }
        
        if message.command != nil {
            switch message.command {
            case .greeting, .fallBack:
                viewModel.message.accept(nil)
                self.tableView.reloadData()
            case .none:
                messageLabel.attributedText = NSAttributedString
                    .makeWith(color: Colors.black, weight: .bold, ofSize: 14, message.value.stringValue())
                messageLabel.isHidden = false
                self.cancelTimer()

            case .stateVAHome, .stateDefaulSuggest:
                isVAHome = true
                setDataSource(message)
                self.setDefaultSuggestView()
                
            case .stateSuggest:
                setDataSource(message)
                self.setSuggestView(icon: .icSuggest, warning: messageString.suggest.rawValue,
                                    detailWarning: messageString.detailSugget.rawValue)

            case .stateComingsoon:
                setDataSource(message)
                self.setSuggestView(icon: .icComingsoon, warning: messageString.comingsoon.rawValue,
                                    detailWarning: messageString.detailComingsoon.rawValue)
                
            case .stateScreenLevel1:
                setDataSource(message)
                self.setSuggestView(icon: .icScreenLevel1, warning: messageString.screenLevel1.rawValue,
                                    detailWarning: messageString.detailScreenLevel1.rawValue)
                
            case .stateDeeplink:
                self.cancelTimer()
                let dataString = message.elements.last.stringValue();
                if dataString.count > 0 {
                    #if DEBUG
                    self.showToast(message: dataString);
                    #endif
                    let deepLink = dataString.replacingOccurrences(of: "link=", with: "")
                    self.openDeepLink(deepLink: deepLink)
                }
                
            case .payBankObject:
                self.cancelTimer()
                message.extraData = DataFlowManager.shared.banks
                self.setupViewInCasePayObject(message: message)
                break
                
            case.payAccountNumber:
                self.cancelTimer()
                self.setupViewInCaseBankSelected(message: message)
                break
                
            case .payConfirm:
                self.hiddenAllAttributes()
                setDataSource(message)
                
            case .payPin:
                self.hiddenAllAttributes()
                setDataSource(message)
                
            default:
                self.cancelTimer()
                setDataSource(message)
            }
            
            self.navigationView.onUpdateUIVAHome(isVAHomeStatus: isVAHome)
        }
        
    }
    
    func openDeepLink( deepLink:String) {
        let tcbURL = URL(string: deepLink)
        if deepLink.count > 0 {
            UIApplication.shared.open(tcbURL!, options: [:])
        }
    }
    
    func resetData() {
        timer = nil
        proccesingCheckTimer = nil
        failCheckTimer = nil
        DataFlowManager.shared.resetData()
    }
    
    func updateUI() {
        let state = DataFlowManager.shared.stateOfAssistant
        
        #if DEBUG
        print("\n TUTM >> update ui:",state)
        #endif
        
        switch state {
        case .activeStateAssistant:
            UIView.animate(withDuration: 0.1, delay: 0.1) {
                self.stateImageView.image = nil
                self.warningLable.text = ""
                self.detailWaringLable.text = ""
            }
        case .processingStateAssistant:
            viewModel.message.accept(nil)
            self.setSuggestView(icon: .icProcessing, warning: messageString.watting.rawValue,
                                detailWarning: messageString.detailWatting.rawValue)

        case .failedStateAssistant:
            //present view controler failed
            viewModel.message.accept(nil)
            self.hiddenAllAttributes()
            let messageDefault = BotMessage(type: BotMessageType.text, value: "_command:DISPLAY|IMMEDIATE|SCREEN_ERROR|data={}")
            self.displayMessage(messageDefault)

        default:
            break
        }
    }
    
    func openErrorViewController() {
        let errorViewController = ErrorViewController()

        if #available(iOS 15.0, *) {
            errorViewController.modalPresentationStyle = .pageSheet //or .overFullScreen for transparency
            if let sheet = errorViewController.sheetPresentationController {
                sheet.detents = [.medium()]
            }
        } else {
            errorViewController.modalPresentationStyle = .custom
            errorViewController.transitioningDelegate = self
        }
        
        errorViewController.onBackVAHome = { [unowned self] in
            self.backAction()
        }
        self.present(errorViewController, animated: true, completion:nil)
    }
    
    func cancelTimer () {
        #if DEBUG
        print("\n TUTM>> Cancel Timer")
        #endif
        
        failCheckTimer = nil
        proccesingCheckTimer = nil
    }
}

extension BankAssistantViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
