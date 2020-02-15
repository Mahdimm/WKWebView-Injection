//
//  MainVC.swift
//  WebView
//
//  Created by Mahdi Mahjoobi on 2/15/20.
//  Copyright © 2020 Mahdi Mahjoobi. All rights reserved.
//

import UIKit
import WebKit

class MainVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        webView.load(URLRequest(url: URL(string: "URL")!))
        
        injectToPage()
    }
    
    // 2
    // MARK: - Reading contents of files
    private func readFileBy(name: String, type: String) -> String {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            return "Failed to find path"
        }
        
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            return "Unkown Error"
        }
    }
    
    // 3
    // MARK: - Inject to web page
    func injectToPage() {
        let cssFile = readFileBy(name: "bootstrap-en", type: "css")
        let jsFile = readFileBy(name: "bootstrap", type: "js")
        
        let cssStyle = """
            javascript:(function() {
            var parent = document.getElementsByTagName('head').item(0);
            var style = document.createElement('style');
            style.type = 'text/css';
            style.innerHTML = window.atob('\(encodeStringTo64(fromString: cssFile)!)');
            parent.appendChild(style)})()
        """
        
        let jsStyle = """
            javascript:(function() {
            var parent = document.getElementsByTagName('head').item(0);
            var script = document.createElement('script');
            script.type = 'text/javascript';
            script.innerHTML = window.atob('\(encodeStringTo64(fromString: jsFile)!)');
            parent.appendChild(script)})()
        """

        let cssScript = WKUserScript(source: cssStyle, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        let jsScript = WKUserScript(source: jsStyle, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        
        webView.configuration.userContentController.addUserScript(cssScript)
        webView.configuration.userContentController.addUserScript(jsScript)
    }
    
    // 4
    // MARK: - Encode string to base 64
    private func encodeStringTo64(fromString: String) -> String? {
        let plainData = fromString.data(using: .utf8)
        return plainData?.base64EncodedString(options: [])
    }

}
