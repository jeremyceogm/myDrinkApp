//
//  SheetDBViewController.swift
//  myDrinkApp
//
//  Created by 黃柏瑜 on 2023/7/18.
//

import UIKit
import WebKit

class SheetDBViewController: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
//https://docs.google.com/spreadsheets/d/1pk5FUOWcvqF5DKRB4Wx6PUz-v7O6DWjCWXJ48qK3How/edit?usp=sharing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = URL(string: "https://docs.google.com/spreadsheets/d/1pk5FUOWcvqF5DKRB4Wx6PUz-v7O6DWjCWXJ48qK3How/edit?usp=sharing")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
