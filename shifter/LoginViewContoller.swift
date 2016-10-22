

import UIKit
import Firebase
import FirebaseDatabase

struct accounts {
    let ID: String!
    let password: String!
}

class LoginViewContoller: UIViewController, UITextFieldDelegate {
    //set test accovar ID/password
    var inputID = String()
    var inputPassword = String()
    var accountArray = [accounts]()
    
    @IBOutlet weak var idTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorStatusLabel: UILabel!
    
    override func viewDidLoad() {
        self.idTextfield.delegate = self
        self.passwordTextfield.delegate = self
        
        //save all users' account to array
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("employee").observeEventType(.ChildAdded, withBlock: { snapshot in
            let getID = snapshot.value!["ID"] as? String
            let getPassword = snapshot.value!["password"] as? String
            self.accountArray.append(accounts(ID: getID, password: getPassword))
        })
    }

    
    @IBAction func pressLogin(sender: UIButton) {
        inputID = idTextfield.text!
        inputPassword = passwordTextfield.text!

        for i in 0...accountArray.count-1{
            if inputID == accountArray[i].ID && inputPassword == accountArray[i].password{
                errorStatusLabel.hidden = true
                performSegueWithIdentifier("showHome", sender: self)
            }else if inputID == "" || inputPassword == ""{
                errorStatusLabel.text = "please enter ID and password"
                errorStatusLabel.hidden = false
            }else{
                errorStatusLabel.text = "ID or password incorrect"
                errorStatusLabel.hidden = false
            }
                
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHome"{
            let tabBarVC = segue.destinationViewController as? TabBarViewController
            tabBarVC!.currentUID = inputID
            let composeVC = BulletinCompose() as BulletinCompose
            composeVC.currentUID = inputID
        }
    }
    
    //resign keyboard when return pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        idTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
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
