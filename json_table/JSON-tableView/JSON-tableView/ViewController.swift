//
//  ViewController.swift
//  JSON-tableView
//
//  Created by 박세라 on 2022/03/11.
//

import UIKit
import Alamofire
import SwiftyJSON

//테이블 뷰에 넣을 item의 배열
var itemArr: Array<MovieItem> = []

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    @IBOutlet var tableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        getMovies()
        
        //위 코드 실행후 1초 후에 dispatchqueue안에 있는 코드를 실행
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            print("tableView setting")
            self.tableView.reloadData()
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    /*Alamofire와 Naver 영화 API를 이용해 item배열 채우기*/
    private func getMovies() {
        let query = "love"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var requestUrl = url_movie + encodedQuery + "&display=10&start=1"
        print(requestUrl)

        AF.request(requestUrl, method: .get, headers: self.headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    //jsonData로 parsing
                    let jsonData = response.data!
                    print(jsonData)

                    let movie = try? JSONDecoder().decode(Movie.self, from: jsonData)

                    for item in (movie?.items)! {
                        var temp = ""
                        temp += "\(item.title)-(\(item.pubDate)) : (\(item.userRating))\n" + "[\(item.actor),\(item.director)]"
                        + "\(item.image) | \(item.link) | \(item.subtitle)\n\n"
                        self.result += temp
                        
                        itemArr.append(item)
                    }
                case .failure(let error):
                    print(error)
                default :
                    print()
                }
            }
    }
    
    //MARK: - UITableViewDelegate, Datasource 우선은 걍 남겨둠....
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //table 각 줄을 담당할 movieCell 가져오기
        let movieCell: MovieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        //영화 이미지 default 사진 설정
        var tempImg = UIImage(named: "noimg.jpg")
        
        //image URL로 이미지 다운로드
        let url = itemArr[indexPath.row].image
        DispatchQueue.global().sync {
            if url != ""{ //url이 nil값이 나올 수도 있어서 체크하기
                if let imgData = try? Data(contentsOf: URL(string:url)!){
                    //print("성공 : \(url)")
                    tempImg = UIImage(data: imgData)!
                    movieCell.imgView.image = tempImg
                } else {
                    tempImg = UIImage(named: "noimg.jpg")!
                    movieCell.imgView.image = tempImg
                }
            }else{
                tempImg = UIImage(named: "noimg.jpg")!
                movieCell.imgView.image = tempImg
            }
        }
        //영화 정보 scripting
        var desc = "감독 : " + itemArr[indexPath.row].director + "\n출연배우 : " + itemArr[indexPath.row].actor + "\n무비링크 : " + itemArr[indexPath.row].link
        
        //movieCell채우기
        movieCell.lblTitle.text = itemArr[indexPath.row].title
        movieCell.textView.text = desc
        movieCell.lblRate.text = itemArr[indexPath.row].userRating
        
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //item Array의 개수를 반환해 테이블이 몇줄 나올지를 알려주는.
        return itemArr.count
    }
}
