//
//  RegisterTableViewController.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/8.
//

import UIKit

class RegisterTableViewController: UITableViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    
//    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func register(_ sender: Any) {
        let url = URL(string:"https://favqs.com/api/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token token=244be7d2528a99aadb16e5be0df72214", forHTTPHeaderField: "Authorization")
        
        let body = LoginRegisterBody(user: UserBody(login: accountTextField.text ?? "", email: "", password: passwordTextField.text ?? ""))
        
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data{
                //印出回傳json //觀察用
                print("印出回傳json")
                print(String(data: data, encoding: .utf8)!)
                
                let decoder = JSONDecoder()
                do {
                    let loginRegisterResponse = try decoder.decode(LoginRegisterResponse.self, from: data)
                    //存入默認以備自動登入用
                    UserDefaults.standard.set(loginRegisterResponse.token, forKey: "token")
                    //
                    UserDefaults.standard.set(loginRegisterResponse.login, forKey: "orderName")
                    
                    DispatchQueue.main.async {
                        //前往NavigationController
                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") {
                            self.present(controller, animated: true)
                        }
                        //跳過NavigationController
                        //排版設計問題
                        //登入頁無NavigationController 指能用present前往頁面 又跳過了NavigationController的話 等於後續也無NavigationController
//                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") {
//                            self.present(controller, animated: true)
//                        }
                    }
                } catch  {
                    let decoder = JSONDecoder()
                    //將底線去掉 連接的第一個字母換成大寫
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    //
                    do {
                        let errorResponse = try decoder.decode(ErrorRespose.self, from: data)
                        DispatchQueue.main.async {
                            let controller = UIAlertController(title: "Error", message: errorResponse.message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "ok", style: .default)
                            controller.addAction(okAction)
                            self.present(controller, animated: true)
                        }
                    } catch {
                        print("輸入錯誤的錯誤")
                        print(error)
                    }
                }
            }
            
            
        }.resume()
    }
    

    // MARK: - Table view data source


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
