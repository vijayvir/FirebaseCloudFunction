import UIKit
import Firebase
import AudioToolbox
class ConversationsVC: HVGenricViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alertBottomConstraint: NSLayoutConstraint!
//    lazy var leftButton: UIBarButtonItem = {
//        let image = UIImage.init(named: "default profile")?.withRenderingMode(.alwaysOriginal)
//        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(ConversationsVC.showProfile))
//        return button
//    }()
    var items = [Conversation]()
    var selectedUser: User?
   var currentUserTemp : String  =  "\(Cookies.userInfo()?.id ?? 0)"
    @IBAction func compose(_ sender: UIButton) {
    }

    
    //MARK: Methods
    func customization()  {
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
//        //NavigationBar customization
//        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
//        // notification setup
//        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
       
        //right bar button
//        let icon = UIImage.init(named: "compose")?.withRenderingMode(.alwaysOriginal)
//        let rightButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(ConversationsVC.showContacts))
//        self.navigationItem.rightBarButtonItem = rightButton
//        //left bar button image fetching
//        self.navigationItem.leftBarButtonItem = self.leftButton
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
     //   if let id = Auth.auth().currentUser?.uid {
//
//            User.info(forUserID: currentUserTemp, completion: { [weak weakSelf = self] (user) in
//                let image = user.profilePic
//                let contentSize = CGSize.init(width: 30, height: 30)
//                UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
//                let _  = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14).addClip()
//                image.draw(in: CGRect(origin: CGPoint.zero, size: contentSize))
//                let path = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14)
//                path.lineWidth = 2
//                UIColor.white.setStroke()
//                path.stroke()
//                let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
//                UIGraphicsEndImageContext()
//                DispatchQueue.main.async {
//                    weakSelf?.leftButton.image = finalImage
//                    weakSelf = nil
//                }
//            })
//        //}
    }
    
    //Downloads conversations
    func fetchData() {
        
        
        Conversation.showConversations(currentUserID : currentUserTemp) { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        self.playSound()
                        break
                    }
                }
            }
        }
    }
    
    //Shows profile extra view
//    @objc func showProfile() {
//        let info = ["viewType" : ShowExtraView.profile]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
//        self.inputView?.isHidden = true
//    }
    
    //Shows contacts extra view
//    @objc func showContacts() {
//        let info = ["viewType" : ShowExtraView.contacts]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
//    }
//
    //Show EmailVerification on the bottom
//    @objc func showEmailAlert() {
//        User.checkUserVerification {[weak weakSelf = self] (status) in
//            status == true ? (weakSelf?.alertBottomConstraint.constant = -40) : (weakSelf?.alertBottomConstraint.constant = 0)
//            UIView.animate(withDuration: 0.3) {
//                weakSelf?.view.layoutIfNeeded()
//                weakSelf = nil
//            }
//        }
//    }
    
    //Shows Chat viewcontroller with given user
    @objc func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    func playSound()  {
//        var soundURL: NSURL?
//        var soundID:SystemSoundID = 0
//        let filePath = Bundle.main.path(forResource: "newMessage", ofType: "wav")
//        soundURL = NSURL(fileURLWithPath: filePath!)
//        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
//        AudioServicesPlaySystemSound(soundID)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
    }

    //MARK: Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 1
        } else {
            return self.items.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items.count == 0 {
            return self.view.bounds.height - self.navigationController!.navigationBar.bounds.height
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationsTBCell
            cell.clearCellData()
            cell.profilePic.image = self.items[indexPath.row].user.profilePic
            cell.nameLabel.text = self.items[indexPath.row].user.name
            switch self.items[indexPath.row].lastMessage.type {
            case .text:
                let message = self.items[indexPath.row].lastMessage.content as! String
                cell.messageLabel.text = message
            case .location:
                cell.messageLabel.text = "Location"
            default:
                cell.messageLabel.text = "Media"
            }
            cell.conversation = self.items[indexPath.row]
            cell.clousureDidSelect = { conversation in
                let vc  : ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                vc.configure(currentUserTemp: self.currentUserTemp, senderUser: (conversation?.user)! , conversation : conversation!)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
//            cell.clousureDidSelect = { user in
//                let vc  : ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
//                vc.configure(currentUserTemp: self.currentUserTemp, senderUser: user!)
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.timeLabel.text = date
            if self.items[indexPath.row].lastMessage.owner == .sender && self.items[indexPath.row].lastMessage.isRead == false {
            
                cell.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
                cell.messageLabel.textColor = GlobalVariables.purple
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.items.count > 0 {
//            self.selectedUser = self.items[indexPath.row].user
//       //     self.performSegue(withIdentifier: "segue", sender: self)
//        }
    }
       
    //MARK: ViewController lifeCycle
    
    func updateDeviceToken(){
        if Cookies.userInfo() != nil {
            if UserDefaults.standard.firebaseToken() != nil  {
                print(UserDefaults.standard.firebaseToken().leoSafe())

                User.updateDeviceToken(forUserID: "\(Cookies.userInfo()!.id)", token: UserDefaults.standard.firebaseToken().leoSafe())
            }
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.fetchData()
        updateDeviceToken()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      //  self.showEmailAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
}





