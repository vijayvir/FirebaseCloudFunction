import UIKit
class HVGenricViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pop(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func popToConversationsVC(_ sender: UIButton) {
        if (self.navigationController != nil) {
            for vc in  self.navigationController!.viewControllers {
                if vc is ConversationsVC {
                     self.navigationController?.popToViewController(vc, animated: false)
                } else if vc is HVCreateGroupViewController {
                    self.navigationController?.popToViewController(vc, animated: false)
                     // sideMenuController?.toggle()
                } else if vc is HVPublicGroupListingViewController {
                    self.navigationController?.popToViewController(vc, animated: false)
                    // sideMenuController?.toggle()
                }
                
                
                
            }
            }
    }
    @IBAction func dissmiss(_ sender: UIButton) {
        self.dismiss(animated: false) {
        }
    }
    @IBAction func toggleSideMenuController(_ sender: UIButton) {
        sideMenuController?.toggle()
        
    }
}
