//
//  OrderTableViewController.swift
//  myDrinkApp
//
//  Created by Jeremy on 2023/6/2.
//

import UIKit

enum OrderTableSection: Int {
    case size, sugar, ice
}

class OrderTableViewController: UITableViewController {
    //每個cell分別拉線 有兩個有三個
    @IBOutlet var sizeCells: [UITableViewCell]!
    @IBOutlet var sugarCells: [UITableViewCell]!
    @IBOutlet var iceCells: [UITableViewCell]!
    
    var drink: Drink!
    var order: Order?
    
    let sizeLargeIndexPath = IndexPath(row: 1, section: OrderTableSection.size.rawValue)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = drink.name
        //作一基本值作為後續判斷顯示基準
        let orderName = UserDefaults.standard.string(forKey: "orderName")!
        order = Order(name: orderName, drink: drink.name, size: Size.m.rawValue, iceLevel: IceLevel.noIce.rawValue, sugarLevel: SugarLevel.halfSugar.rawValue, price: drink.info.m)
//        Order(name: <#T##String#>, drink: <#T##String#>, size: <#T##String#>, iceLevel: <#T##String#>, sugarLevel: <#T##String#>, price: <#T##Int#>)
        
        updateSizeCells()
        updateSugerCells()
        updateIceCells()
        
    }

    func updateSugerCells(){
        for cell in sugarCells{
            cell.accessoryType = .none
        }
        //allCases 將列舉內容取出 變成類似陣列的屬性
        for(i,suger) in SugarLevel.allCases.enumerated(){
            if order?.sugarLevel == suger.rawValue{
                sugarCells[i].accessoryType = .checkmark
                break
            }
        }
    }
    
    func updateIceCells() {
        for cell in iceCells {
            cell.accessoryType = .none
        }
        
        for (i, ice) in IceLevel.allCases.enumerated() {
            if ice.rawValue == order?.iceLevel {
                iceCells[i].accessoryType = .checkmark
                break
            }
        }
    }
    
    func updateSizeCells() {
        for cell in sizeCells {
            cell.accessoryType = .none
        }
        
        for (i, size) in Size.allCases.enumerated() {
            if size.rawValue == order?.size {
                sizeCells[i].accessoryType = .checkmark
                break
            }
        }
    }
    
    func showSuccessAlert(){
        let alert = UIAlertController(title: "訂單完成", message: "如題", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "確定", style: .default) { [self] _ in
//            self.navigationController?.popViewController(animated: true)
            let controller = storyboard?.instantiateViewController(withIdentifier: "SheetDBViewController") as! SheetDBViewController
            navigationController?.pushViewController(controller, animated: true)
        }
        alert.addAction(okaction)
//        alert.actions //用途是？
        present(alert, animated: true)
    }
    //MARK: - 按鈕行為
    @IBAction func done(_ sender: Any) {
        print(order!)
        let url = URL(string: "https://sheetdb.io/api/v1/bioaauwsft332")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //Content-Type: application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        //依api文件傳送data陣列
        
        let body = OrderBody(data: [order!])
        request.httpBody = try? encoder.encode(body)
        
//        request.httpBody = try? JSONEncoder().encode(OrderBody(data: [order!]))
        //師版建議把order用guard let解封
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data{
                let decoder = JSONDecoder()
                do {
                    //[String:Int]為特殊寫法 簡單結構下可用 免自設JSON格式
                    let dic = try decoder.decode([String:Int].self, from: data)
                    if dic["created"] == 1{
                        DispatchQueue.main.async {
                            self.showSuccessAlert()
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
        
        //
        
        
    }
    
    
    
    //MARK: - 代理行為
    //決定表格各個位置的高度//沒大杯時隱藏大杯選項
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == sizeLargeIndexPath,drink.info.l == nil{
            return 0
        }
        //用自動高度
        return UITableView.automaticDimension
    }
    
    //表格被點擊時行為
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderSecion = OrderTableSection(rawValue: indexPath.section)
        
        switch orderSecion{
        case .size:
            order?.size = Size.allCases[indexPath.row].rawValue
            //size跟價格有關 所以要有關連改變
            if order?.size == "中"{
                order?.price = drink.info.m
            }else{
                order?.price = drink.info.l!
            }
            updateSizeCells()
        case .sugar:
            order?.sugarLevel = SugarLevel.allCases[indexPath.row].rawValue
            updateSugerCells()
        case .ice:
            order?.iceLevel = IceLevel.allCases[indexPath.row].rawValue
            updateIceCells()
        //orderSecion 是用rawValue值生成的 為選擇值所以有default //可能為nil
        default:
            return
        }
        
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
