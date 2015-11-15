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
    var currentPage = 1
    var isLoading = false
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
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
        print("----------\(currentPage)")
        let request = JokeTextRequest(time: "2015-01-01", page: currentPage)
        isLoading = true
        Alamofire.request(.GET, request.url).responseJSON { response in
            print(response.request?.URLString)
            if response.result.isSuccess {
                if let value = response.result.value {
                    Response.sharedManager.setData(value)
                    self.tableView.reloadData()
                }
            } else {
                response.result.error
            }
            self.isLoading = false
            self.refreshControl.endRefreshing()
        }
    }
    
    func refreshData() {
        currentPage = 1
        requestData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Response.sharedManager.contentList.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(JokeViewCell.ID) as? JokeViewCell
        if cell == nil {
            cell = JokeViewCell(style: .Subtitle, reuseIdentifier: JokeViewCell.ID)
        }
        
        let jokeItem = Response.sharedManager.contentList[indexPath.row]
        cell?.titleLabel.text = jokeItem.title
        cell?.ctLabel.text = jokeItem.ct.substringToIndex(jokeItem.ct.endIndex.advancedBy(-4))

        cell?.contentLabel.attributedText = NSAttributedString(string: jokeItem.text, attributes: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType])
        cell?.contentLabel.numberOfLines = 0
        cell?.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.isLoading {
            return
        }
        
        let space = CGFloat(10)
        let y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom
        //print("y:\(y), height:\(scrollView.contentSize.height), table height:\(self.tableView.frame.height)")
        if y > scrollView.contentSize.height + space {           // 滑到底部
            ++currentPage
            if currentPage > Response.sharedManager.allPages {
                currentPage = 1
            }
            requestData()
        }
    }
    
}