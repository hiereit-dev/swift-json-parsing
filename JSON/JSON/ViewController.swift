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


var movieTitle: [String] = []
var movieDesc: [String] = []
var movieImage: [String] = []

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tfQuery: UITextField!
    
    /*info.plist에서 API key값 가져오기*/
    let infoDict = Bundle.main.infoDictionary!
    lazy var NAVER_CLIENT_ID = infoDict["NAVER_ClientId"] as! String
    lazy var NAVER_CLIENT_SECRET = infoDict["NAVER_SecretKey"] as! String
    
    /*api관련 변수 선언*/
    let url = "https://openapi.naver.com/v1/search/local.json?query="
    let url_movie = "https://openapi.naver.com/v1/search/movie.json?query="
    var result = ""
    
    
    //ISSUE1) HTTPHeader가 안된 이유 : Alamofire의 버전 문제. & lazy var로 선언하지 않았음.
    lazy var header1 = HTTPHeader(name:"X-Naver-Client-Id", value: NAVER_CLIENT_ID)
    lazy var header2 = HTTPHeader(name:"X-Naver-Client-Secret", value: NAVER_CLIENT_SECRET)
    lazy var headers = HTTPHeaders([header1, header2])

    var sampleImage = UIImage(named: "noimg.jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnMovieSearch(_ sender: UIButton) {
        let query = String(tfQuery.text!)
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var requestUrl = url_movie + encodedQuery + "&display=10&start=1"
        
        print(requestUrl)
        
        AF.request(requestUrl, method: .get, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
    
                    //jsonData로 parsing
                    let jsonData = response.data!
                    print(jsonData)
                    
                    let movie = try? JSONDecoder().decode(Movie.self, from: jsonData)
                    //print(movie)
                    for item in (movie?.items)! {
                        var temp = ""
                        temp += "\(item.title)-(\(item.pubDate)) : (\(item.userRating))\n" + "[\(item.actor),\(item.director)]"
                        + "\(item.image) | \(item.link) | \(item.subtitle)\n\n"
                        self.result += temp
                        
                        movieTitle.append(item.title)
                        movieDesc.append(item.link)
                        movieImage.append(item.image)
                        
                    }
                    self.textView.text = self.result
                    print(self.result)
                    self.result = ""
                    
                case .failure(let error):
                    print(error)
                default :
                    print()
                }
            }
    }
    @IBAction func btnSearch(_ sender: UIButton) {
        let query = String(tfQuery.text!)
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var requestUrl = url + encodedQuery + "&display=5&start=1&sort=comment"
        print("requestUrl:\(requestUrl)")
        
        AF.request(requestUrl, method: .get, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                //case .success:
                case .success(let value as [String: Any]):
                    //jsonString parsing하는 법

                    let json = JSON(value)
                    print(json)
                    self.textView.text = json.rawString()
                    self.parseJSON(json)
                    
                    //jsonData로 parsing - Codable Struct 사용
                    /*
                    let jsonData = response.data!
                    //print(jsonData)
                    let place = try? JSONDecoder().decode(Place.self, from: jsonData)
                    print(place)
                    for item in (place?.items)! {
                        var temp = ""
                        temp += "\(item.title) : \(item.category)\n" + "[\(item.mapx),\(item.mapy)]"
                        + "\(item.address) | \(item.link) | \(item.telephone)\n\n"
                        self.result += temp
                    }
                    self.textView.text = self.result
                    self.result = ""
                     */
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
//MARK: - UITableViewDelegate, Datasource 우선은 걍 남겨둠....
extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {, UITableViewDataSource
//
//        return UITableViewCell.
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
