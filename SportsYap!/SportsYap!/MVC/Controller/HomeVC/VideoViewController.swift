//
//  VideoViewController.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 17/10/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {
    @IBOutlet private weak var webVwMain: UIWebView!
    var strLink = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        webVwMain.loadRequest(URLRequest(url: URL(string: strLink)!))
        //webVwMain.loadRequest(NSURLRequest(URL: NSURL(string: "strLink") as! URL) as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnBackClicked(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
