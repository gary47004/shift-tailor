

import UIKit
import Firebase
import FirebaseDatabase

struct accounts {
    let ID: String!
    var password: String!
    let store: String!
    let district : String!
    let rank : String!
    let profession : String!
}



class LoginViewContoller: UIViewController, UITextFieldDelegate {
    var inputID = String()
    var inputPassword = String()
    var accountArray = [accounts]()
    var IDArray = [String]()
    var passwordArray = [String]()

    
    @IBOutlet weak var idTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorStatusLabel: UILabel!
    
    override func viewDidLoad() {

        //UI
        idTextfield.underlined()
        passwordTextfield.underlined()
        
        //keyboard observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewContoller.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewContoller.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
        //save all user accounts to array
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("employee").observeEventType(.ChildAdded, withBlock: { snapshot in
            let ID = snapshot.value!["ID"] as? String
            let password = snapshot.value!["password"] as? String
            let store = snapshot.value!["store"] as? String
            let district = snapshot.value!["district"] as? String
            let rank = snapshot.value!["rank"] as? String
            let profession = snapshot.value!["profession"] as? String
            
            self.accountArray.append(accounts(ID: ID, password: password, store: store, district: district, rank: rank, profession: profession))
            self.IDArray.append(ID!)
            self.passwordArray.append(password!)
        })
        
        //when password changed
        databaseRef.child("employee").observeEventType(.ChildChanged, withBlock: { snapshot in
            let ID = snapshot.value!["ID"] as? String
            let password = snapshot.value!["ID"] as? String

            let index = self.IDArray.indexOf({ $0 == ID })
            self.accountArray[index!].password = password
            self.passwordArray[index!] = password!
        })
    }

    
    @IBAction func pressLogin(sender: UIButton) {

        inputID = idTextfield.text!
        inputPassword = passwordTextfield.text!
        
        
        //check-up account
        for _ in 0...accountArray.count-1{
            
            if inputID == "" || inputPassword == ""{
                errorStatusLabel.text = "please enter ID and password"
                errorStatusLabel.hidden = false
            }else if IDArray.contains(inputID) == false{
                errorStatusLabel.text = "user not found"
                errorStatusLabel.hidden = false
            }else if IDArray.contains(inputID) == true{
                if let index = IDArray.indexOf({ $0 == inputID }){
                    if inputPassword != passwordArray[index]{
                        errorStatusLabel.text = "password incorrect"
                        errorStatusLabel.hidden = false
                    }else{
                        errorStatusLabel.hidden = true
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(inputID, forKey: "currentUID")
                        defaults.setObject(accountArray[index].store, forKey: "currentSID")
                        defaults.setObject(accountArray[index].district, forKey: "currentDID")
                        defaults.setObject(accountArray[index].rank, forKey: "currentRank")
                        defaults.setObject(accountArray[index].password, forKey: "currentPassword")
                        defaults.setObject(accountArray[index].profession, forKey: "currentProfession")
                        defaults.setBool(true, forKey: "loggedin")

                        performSegueWithIdentifier("showHome", sender: self)
                    }
                }
            }
        }
    }
    
    //resign keyboard when return pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isFirstResponder() == true{
            textField.placeholder = nil
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == ""{
            if textField == idTextfield{
                textField.placeholder = "ID"
            }else{
                textField.placeholder = "password"
            }
        }
    }
    
    //scroll view when keyboard toggled
    func keyboardWillShow(notification: NSNotification){
//        if self.view.subviews[0].frame.origin.y == 114{
//            self.view.subviews[0].frame.origin.y += 86
//        }
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue(){
            if view.frame.origin.y == 0{
                view.frame.origin.y -= keyboardSize.height - 100
            }
            
        }
    }

    func keyboardWillHide(notification: NSNotification){
//        self.view.subviews[0].frame.origin.y -= 86
        
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue(){
            if view.frame.origin.y != 0{
                view.frame.origin.y += keyboardSize.height - 100
            }
            
        }
    }
}


class ForgotPasswordViewController: UIViewController{
    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginVC")
    
    @IBAction func backButton(sender: UIBarButtonItem) {
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
    @IBAction func sendViaText(sender: UIButton) {
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
    @IBAction func sendViaEmail(sender: UIButton) {
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
}
