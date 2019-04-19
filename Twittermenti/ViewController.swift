//
//  ViewController.swift
//  Twittermenti
//
//  Created by Emanuel Covaci on 15/04/2019.
//

import UIKit
import SwifteriOS
import CoreData

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
    
        
       let swifter = Swifter(consumerKey: "kYVs9bqA0cviHvMKENap3aWZ2", consumerSecret: private_API_key)
        swifter.searchTweet(using: "@Apple", lang: "en", count: 1, tweetMode: .extended, success: { (result, metadata) in
          //  print(result)
        }){(error)in print("That was an error with Twitter API \(error)")}
        
        let sentimentClassifier = TweetSentimentalClassifier()
        
        let predict = try! sentimentClassifier.prediction(text: "Apple is the best!")
        
        print(predict.label)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

