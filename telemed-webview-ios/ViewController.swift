//
//  ViewController.swift
//  telemed-webview-ios
//
//  Created by Gustavo Diogo Silva on 02/06/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        
        if let userScriptURL = Bundle.main.url(forResource: "UserScript", withExtension: "js") {

            let userScriptCode = try! String(contentsOf: userScriptURL)
            let userScript = WKUserScript(source: userScriptCode, injectionTime: .atDocumentStart, forMainFrameOnly: false)

            configuration.userContentController.addUserScript((userScript))
        }
        
        
        webView = WKWebView(
            frame: .zero, configuration: configuration
        )
        
        webView.uiDelegate = self
        view = webView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
            scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "https://develop.telemedicina.drtis.com.br") else {
            return
        }
        webView.load(URLRequest(url: url))
        webView.scrollView.isMultipleTouchEnabled = false
        self.webView.scrollView.delegate = self
   
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.webView.evaluateJavaScript("document.body.innerHTML") { result, error in guard let html = result as? String, error == nil else {
                return
            }
                print(html)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }


}

