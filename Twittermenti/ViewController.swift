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
    
    let tweetsCount = 100
    
    var swifter:Swifter = Swifter(consumerKey: "", consumerSecret: "")
    


    override func viewDidLoad() {
        super.viewDidLoad()
       
        guard let path = Bundle.main.path(forResource: "Property List", ofType: "plist") else { fatalError()}
        let dict = NSDictionary(contentsOfFile: path)
        
        let public_API_key = (dict?["public_key"]!) as! String
        let private_API_key = (dict?["private_key"]!) as! String

        
        swifter = Swifter(consumerKey: "", consumerSecret: "")


        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

    }

    @IBAction func predictPressed(_ sender: Any) {
        fetchTweets()
        
        }
    
    func fetchTweets(){
        let text = textField.text!
        sentimentLabel.text = "⏳"
        
        
        swifter.searchTweet(using: text, lang: "en", count: tweetsCount, tweetMode: .extended, success: { (result, metadata) in
            var  tweets = [TweetSentimentalClassifierInput]()
            
            for i in 0..<self.tweetsCount{
                if let tweet = result[i]["full_text"].string  {
                    let tweetInputClassifier = TweetSentimentalClassifierInput(text: tweet)
                    tweets.append(tweetInputClassifier)
                }
            }
            self.makePrediction(with: tweets)
        }){(error)in print("That was an error with Twitter API \(error)")}
        
        
    }
    
    func makePrediction(with tweets: [TweetSentimentalClassifierInput]){
        let sentimentClassifier = TweetSentimentalClassifier()
        
        do{
            let predictions = try sentimentClassifier.predictions(inputs: tweets)
            
            var neutral = 0
            var positiveScore = 0
            var negativeScore = 0
            var sentimentalScore = 0
            
            
            
            for prediction in predictions{
                if prediction.label == "Pos" {
                    positiveScore = positiveScore + 1
                    sentimentalScore = sentimentalScore + 1
                }
                if (prediction.label == "Neg"){
                    negativeScore = negativeScore + 1
                    sentimentalScore = sentimentalScore - 1
                }
                
            }
            
            neutral = 100 - positiveScore - negativeScore
            
            print("Positive:\(positiveScore)")
            print("Negative:\(negativeScore)")
            print("neutral:\(neutral)")
            print("Sentimental score: \(sentimentalScore)")
            updateUI(with: sentimentalScore)
            
            
           
            
        }catch{
            print("Error in prediction stage \(error)")
        }
        
    }
    
    func updateUI(with sentimentalScore:Int){
        
        if sentimentalScore > 20 {
            self.sentimentLabel.text = "😍"
        }else if sentimentalScore > 10 {
            self.sentimentLabel.text = "☺️"
        }else if sentimentalScore > 0 {
            self.sentimentLabel.text = "😀"
        }else if sentimentalScore == 0{
            self.sentimentLabel.text = "😐"
        }else if sentimentalScore > -10{
            self.sentimentLabel.text = "😢"
        }else if sentimentalScore > -20{
            self.sentimentLabel.text = "😤"
        }else {
            self.sentimentLabel.text = "🤮"
        }
    }
    
}

