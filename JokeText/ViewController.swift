//
//  ViewController.swift
//  JokeText
//
//  Created by tutujiaw on 15/11/11.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getColor(color:Int32) -> UIColor{
        let red = CGFloat((color&0xff0000)>>16)/255
        let green = CGFloat((color&0xff00)>>8)/255
        let blue = CGFloat(color&0xff)/255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func requestData() {
        self.view.makeToastActivity()
        let request = LaifuJokeRequest()
        isLoading = true
        Alamofire.request(.GET, request.url).responseJSON { response in
            if response.result.isSuccess {
                if let value = response.result.value {
                    LaifuResponse.sharedManager.setData(value)
                    self.tableView.reloadData()
                }
            }
            self.isLoading = false
            self.view.hideToastActivity()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LaifuResponse.sharedManager.list.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(JokeViewCell.ID) as? JokeViewCell
        if cell == nil {
            cell = JokeViewCell(style: .Subtitle, reuseIdentifier: JokeViewCell.ID)
        }
        
        do {
            let jokeItem = LaifuResponse.sharedManager.list[indexPath.row]
            cell?.titleLabel.text = jokeItem.title
            cell?.ctLabel.text = ""
            let htmlContent = jokeItem.content.dataUsingEncoding(NSUTF32StringEncoding, allowLossyConversion: false)
            if let htmlContent = htmlContent {
                let attrContent = try NSAttributedString(data: htmlContent, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                cell?.contentLabel.attributedText = attrContent
                cell?.contentLabel.numberOfLines = 0
                cell?.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)
            }
        } catch {
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.isLoading {
            return
        }
        
        let space = CGFloat(20)
        let y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom
        //print("y:\(y), height:\(scrollView.contentSize.height), table height:\(self.tableView.frame.height)")
        if y > scrollView.contentSize.height + space {           // 滑到底部
            requestData()
        }
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        if action == Selector("copy:") {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? JokeViewCell {
                UIPasteboard.generalPasteboard().string = cell.contentLabel.text
            }
        }
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return action == Selector("copy:")
    }
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}