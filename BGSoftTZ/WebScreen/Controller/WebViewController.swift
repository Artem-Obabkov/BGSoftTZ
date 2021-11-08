//
//  WebViewController.swift
//  BGSoftTZ
//
//  Created by pro2017 on 08/11/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var urlString: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    
    @IBAction func goBackAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func loadWebView() {
        
        guard
            let urlString = urlString,
            let url = URL(string: urlString)
        else { return }
        
        let urlRequest = URLRequest(url: url)
        
        webView.load(urlRequest)
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
}
