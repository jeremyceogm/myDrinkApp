//
//  SaveDrinkTableViewController.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/8.
//

import UIKit

class SaveDrinkTableViewController: UITableViewController {
    
    var drinks = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = UserDefaults.standard.data(forKey: "drinks"),
           let drinks = try? JSONDecoder().decode([Drink].self, from: data) {
            self.drinks = drinks
        }
    }
    
    // MARK: - Table view data source
    
   //當執行編輯動作(刪除)時會呼叫
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        drinks.remove(at: indexPath.row)
        let data = try? JSONEncoder().encode(drinks)
        if let data {
            UserDefaults.standard.set(data, forKey: "drinks")

        }
        //實際刪除動作
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //"\(MenuCellTableViewCell.self)" 這樣寫是避免打錯字
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MenuCellTableViewCell.self)", for: indexPath) as! MenuCellTableViewCell

        // Configure the cell...
        let drink = drinks[indexPath.row]
        cell.nameLab.text = drink.name
        cell.priceLab.text = "NT$\(drink.info.m)"
        cell.imageV.image = UIImage(named: "milkshoptea")
        
        if let urlString = "https://raw.githubusercontent.com/jeremyceogm/milksha/main/milkshaPng/\(drink.name).png".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let imageURL = URL(string: urlString) {

            cell.imageV.kf.setImage(with: imageURL, placeholder: UIImage(named: "milkshoptea"))

        }
        
        return cell
    }

}

//#Preview {
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    return storyboard.instantiateViewController(withIdentifier: "SaveDrinkTableViewController")
//}
