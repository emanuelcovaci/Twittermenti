//
//  ViewController.swift
//  Twittermenti
//
//  Created by Emanuel Covaci on 15/04/2019.
//

import UIKit
import SwifteriOS
import CoreData
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
   // var swifter:Swifter = Swifter(consumerKey: "", consumerSecret: "")
    


    override func viewDidLoad() {
        super.viewDidLoad()
       
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else { fatalError()}
        let dict = NSDictionary(contentsOfFile: path)
        
        let public_API_key = (dict?["public_key"]!) as! String
        let private_API_key = (dict?["private_key"]!) as! String
        let sentimentClassifier = TweetSentimentalClassifier()
    
        
       let swifter = Swifter(consumerKey: "kYVs9bqA0cviHvMKENap3aWZ2", consumerSecret: private_API_key)
        swifter.searchTweet(using: "@Facebook", lang: "en", count: 100, tweetMode: .extended, success: { (result, metadata) in
        var  tweets = [TweetSentimentalClassifierInput]()
        
            for i in 0..<100{
                if let tweet = result[i]["full_text"].string  {
                       let tweetInputClassifier = TweetSentimentalClassifierInput(text: tweet)
                       tweets.append(tweetInputClassifier)
                }
            }
            
            do{
                let predictions = try sentimentClassifier.predictions(inputs: tweets)
                
                var sentimentalScore = 0
                
                
                
                for prediction in predictions{
                    if prediction.label == "Pos" {
                        sentimentalScore = sentimentalScore + 1
                    }else if (prediction.label == "Neg"){
                        sentimentalScore = sentimentalScore - 1
                        
                    }
                    
                }
                
                print(sentimentalScore)
                
            }catch{
                print("Error in prediction stage \(error)")
            }
        }){(error)in print("That was an error with Twitter API \(error)")}
        

        
    
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

