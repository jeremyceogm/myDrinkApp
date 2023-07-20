//
//  LoginTableViewController.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/8.
//

import UIKit

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameOrEmailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    @IBAction func login(_ sender: Any) {
        //session會議 表示登入後保持登入狀態
        let url = URL(string: "https://favqs.com/api/session")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token token=244be7d2528a99aadb16e5be0df72214", forHTTPHeaderField: "Authorization")
        
        let body = LoginRegisterBody(user: UserBody(login: nameOrEmailTextField.text ?? "", password: passwordTextField.text ?? ""))
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, erroe in
            if let data{
                print(String(data: data, encoding: .utf8)!)
                do {
                    let loginRegisterResponse = try JSONDecoder().decode(LoginRegisterResponse.self, from: data)
                    
                    //將值存入app中
                    UserDefaults.standard.set(loginRegisterResponse.token, forKey: "token")
                    //
                    UserDefaults.standard.set(loginRegisterResponse.login, forKey: "orderName")
                    
                    DispatchQueue.main.async {
                        
                        //
                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") {
                            //此法會讓帳密頁留下 不好
                            //self.present(controller, animated: true)
                            self.view.window?.rootViewController = controller
                        }
                    }
                } catch {
                    let decoder = JSONDecoder()
                    //解碼的對應策略 ＝ 將蛇形命名法（error_code）改成駝峰命名法（errorCode）
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    //再做一次do-catch
                    do {
                        let errorResponse = try decoder.decode(ErrorRespose.self, from: data)
                        DispatchQueue.main.async {
                            let controller = UIAlertController(title: "Error", message: errorResponse.message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default)
                            controller.addAction(okAction)
                            self.present(controller, animated: true)
                        }
                    } catch {
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
