//
//  ViewController.swift
//  myDrinkApp
//
//  Created by Jeremy on 2023/6/2.
//

import UIKit
import Kingfisher

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   

    @IBOutlet weak var tableV: UITableView!
    
    var menu = [Menu]()
    var saveDrinks = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableV.dataSource = self
        tableV.delegate = self
        
        //https://raw.githubusercontent.com/jeremyceogm/milksha/main/Milksha.json
        //https://raw.githubusercontent.com/PeterPanSwift/JSON_API/main/Milksha.json
        let url = URL(string: "https://raw.githubusercontent.com/jeremyceogm/milksha/main/Milksha.json")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data{
//                let decoder = JSONDecoder()
                do {
                    self.menu = try JSONDecoder().decode([Menu].self, from: data)

                    DispatchQueue.main.async {
                        self.tableV.reloadData()
                    }
                } catch  {
                    print(error)
                }
            }
        }.resume()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //將存在UserDefaults的data解碼出來
        if let data = UserDefaults.standard.data(forKey: "drinks"),
           let drinks = try? JSONDecoder().decode([Drink].self, from: data){
            saveDrinks = drinks
            tableV.reloadData()
        }
//        UserDefaults.standard.array(forKey: "drinks") //為何不用 //因這array只能存基本資料

        
    }
    //MARK: - 按鈕
    @IBAction func heartButtonTap(_ sender: UIButton) {
        //找尋按鈕位置
        let point = sender.convert(CGPoint.zero, to: tableV)
        //位置轉換成indexPath
        let indexPath = tableV.indexPathForRow(at: point)
        
        //以上貌似能直接改用以下寫法 //直接拿row section
//        let row = tableV.indexPathForSelectedRow?.row
//        let section = tableV.indexPathForSelectedRow?.section
        //好像不行 沒按cell
        
        //收藏邏輯
        if let indexPath{
            //所選位置飲料
            let drink = menu[indexPath.section].drinks[indexPath.row]
            //在滿心狀態時按按鈕
            if sender.isSelected{
                //在saveDrinks由前面開始找同名的位置
                let index = saveDrinks.firstIndex { sDrink in
                    sDrink.name == drink.name
                    //sDrink == drink //不行,因為Drink型態沒法比較
                    //此法遇到多個同名怎半 //用indices可解
                }
//                //上面得到的是Int 下列得到的是arr
//                let arr = saveDrinks.filter { sDrink in
//                    sDrink.name == drink.name
//                }
//                //另用indices可以另外儲存有匹配到的saveDrinks索引值
//                let indices = saveDrinks.indices.filter { index in
//                    saveDrinks[index].name == drink.name
//                }
//                //在用以下方法的到全部符合的索引值
//                for index in indices {
//                    // 使用 index 处理索引值
//                    print(index)
//                }
                
                if let index{
                    saveDrinks.remove(at: index)
                }
                
            }else{
                saveDrinks.append(drink)
            }
            //存入暫存檔
            if let data = try? JSONEncoder().encode(saveDrinks){
                UserDefaults.standard.set(data, forKey: "drinks")
            }
//            UserDefaults.standard.set(saveDrinks, forKey: "drinks") //如果之後可直接讀陣列可用 //不行 存陣列只有基本的[Int],  [String]可以
            //選定Row重讀 減少loading //記.automatic
            tableV.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    
    @IBAction func SheetDBbuttTap(_ sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SheetDBViewController") as! SheetDBViewController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        //移除暫存
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "orderName")
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") {
            //將目前顯示的根控制器轉變 //會釋放其他畫面 只剩根畫面
            view.window?.rootViewController = controller
        }
    }
    
    
    @IBSegueAction func showOrderView(_ coder: NSCoder) -> OrderTableViewController? {
        if let indexPath = tableV.indexPathForSelectedRow{
            let controller = OrderTableViewController(coder: coder)
            controller?.drink = menu[indexPath.section].drinks[indexPath.row]
            return controller
        }else{
            return nil
        }
        
    }
    
    
    // ViewController的表格不能用靜態生成的 不適合此專案 //應該是剛開始
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = storyboard?.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
//        navigationController?.pushViewController(controller, animated: true)
//        
//    }
    //MARK: - UITableViewDataSource
    
    //
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        menu[section].category
    }
    
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menu[section].drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellTableViewCell", for: indexPath) as! MenuCellTableViewCell
        
        let drink = menu[indexPath.section].drinks[indexPath.row]
        cell.nameLab.text = drink.name
        cell.priceLab.text = "NT$\(drink.info.m)"
        
        //contains回傳bool
        let content = saveDrinks.contains { sDrink in
            sDrink.name == drink.name
        }
        //搭配storyboard設定改變按鈕圖案
        cell.heartButton.isSelected = content
        
        //將含有中文的網址轉成％文字 //記.add //記.urlQueryAllowed
        //"https://raw.githubusercontent.com/jeremyceogm/milksha/main/milkshaPng/\(drink.name).png"
        //"https://raw.githubusercontent.com/PeterPanSwift/JSON_API/main/\(drink.name).png"
        if let urlString = "https://raw.githubusercontent.com/jeremyceogm/milksha/main/milkshaPng/\(drink.name).png".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let imageUrl = URL(string: urlString){
            
            //找不到網路圖時用設定圖 //記.kf.setImage//記,placeholder:
            cell.imageV.kf.setImage(with:imageUrl ,placeholder: UIImage(named: "milkshoptea"))
            
        }
        
        
        
        return cell
    }
    
}

