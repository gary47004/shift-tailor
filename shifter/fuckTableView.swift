import UIKit

class fuckTableView: UITableViewController {
    
    let catArray = ["lion","tiger","lepeord","Jaguar"]
    
    let bikeArray = ["Harley","Triumph","Troton"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 //多個section要改tableview的style
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return catArray.count
        }else{
            return bikeArray.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { //cell裡要顯示什麼
        //            let cell = UITableViewCell() //產生一個cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) //讓離開畫面的cell重複使用 不用再產生新的
        if indexPath.section == 0{
            cell.textLabel?.text = catArray[indexPath.row] //cell有預設的textlabel 有幾個cell執行幾次 每次參數indexPath會++ .row代表第幾行
        }else{
            cell.textLabel?.text = bikeArray[indexPath.row]
        }
        return cell
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Cats"
        }else{
            return "Bikes"
        }
    }
    
}
