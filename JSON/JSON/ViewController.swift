//
//  ViewController.swift
//  JSON
//
//  Created by 박세라 on 2022/03/08.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tfQuery: UITextField!
    
    let infoDict = Bundle.main.infoDictionary!
    
    lazy var NAVER_CLIENT_ID = infoDict["NAVER_ClientId"] as! String
    lazy var NAVER_CLIENT_SECRET = infoDict["NAVER_SecretKey"] as! String
    
    
    let url = "https://openapi.naver.com/v1/search/local.json?query="
    var result = ""
    //ISSUE - HTTPHeader가 안된 이유 : Alamofire의 버전 문제. & lazy var로 선언하지 않았음.
    
    lazy var header1 = HTTPHeader(name:"X-Naver-Client-Id", value: NAVER_CLIENT_ID)
    lazy var header2 = HTTPHeader(name:"X-Naver-Client-Secret", value: NAVER_CLIENT_SECRET)
    lazy var headers = HTTPHeaders([header1, header2])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //
    }
        
    @IBAction func btnSearch(_ sender: UIButton) {
        let query = String(tfQuery.text!)
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var requestUrl = url + encodedQuery + "&display=5&start=1&sort=comment"
        print("requestUrl:\(requestUrl)")
        
        AF.request(requestUrl, method: .get, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String: Any]):
                    let json = JSON(value)
                    print(json)
                    self.textView.text = json.rawString()
                    print("HELLO:", json.stringValue)
                    self.parseJSON(json)
                case .failure(let error):
                    print(error)
                default :
                    print()
                }
                
            }
        
    }
    func parseJSON(_ json: JSON){
        print(json["items"])
        let items = json["items"]
        for item in items {
            var temp = ""
            temp = temp + "장소:" + item.1["title"].stringValue
            + "\n주소:" + item.1["address"].stringValue
            + "\nLatLng: [" + item.1["mapx"].stringValue + ", " + item.1["mapy"].stringValue + "]\n\n"
            result += temp
        }
        textView.text = result
        result = ""
    }
    
}
