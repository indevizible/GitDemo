//
//  DemoTableViewController.swift
//  GitDemo
//
//  Created by Nattawut Singhchai on 1/24/16.
//  Copyright © 2016 Nattawut Singhchai. All rights reserved.
//  inspire from dribble https://dribbble.com/shots/1866032-Candidate-Profile-Talent-Scout-iPhone-6-app

import UIKit
import Charts
import Alamofire

class DemoTableViewController: UITableViewController {
    
    weak var tmpTopConstraint: NSLayoutConstraint?
    
    var sources: [[String:AnyObject]]? {
        get {
            return data?["data"] as? [[String:AnyObject]]
        }
    }
    
    var data: [String:AnyObject]?
    
    var attributedStrings = [NSIndexPath:NSAttributedString]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "DemoHeaderView", bundle: NSBundle.mainBundle()), forHeaderFooterViewReuseIdentifier: "DemoHeaderView")
        Alamofire.request(.GET, "https://raw.githubusercontent.com/indevizible/GitDemo/master/SampleData.plist").responsePropertyList { result in
            switch result.result {
            case .Success(let plist):
                self.data = plist as? [String : AnyObject]
                self.tableView.reloadData()
            case .Failure(let error):
                let alertView = UIAlertController(title: "Failure", message: error.localizedDescription, preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
        
    
        if let data = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("SampleData", withExtension: "plist")!) as? [String:AnyObject]{
            self.data = data

            tableView.reloadData()
        }

    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as? DemoCell ,sources = sources?[indexPath.row] {
            cell.topLine.hidden = indexPath.row == 0
            
            let isLastLine = (self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1)  == indexPath.row
            cell.bottomLine.hidden = isLastLine
            cell.separatorView.hidden = isLastLine
            
            if let details = sources["details"] as? String, title = sources["title"] as? String {
                if let attributedString = attributedStrings[indexPath] {
                    cell.detailsLabel?.attributedText = attributedString
                }else{
                    let attributedString = NSAttributedString(string: details, attributes: DemoCell.attributeForDetails())
                    attributedStrings[indexPath] = attributedString
                    cell.detailsLabel.attributedText = attributedString
                }
                
                cell.headerTitleLabel.attributedText = NSAttributedString(string: title.uppercaseString, attributes: DemoCell.attributeForTitle())
                
                cell.setChart(sources["chart"] as? [String:Int])
            }
            
            
        }

        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var chartHeight:CGFloat = 0
        
        if let _ = sources?[indexPath.row]["chart"] as? [String:Int] {
            chartHeight = 201
        }
        
        guard let attributedString = attributedStrings[indexPath] else {
            if let details = sources?[indexPath.row]["details"] as? String {
                let attributedString = NSAttributedString(string: details, attributes: DemoCell.attributeForDetails())
                attributedStrings[indexPath] = attributedString
                return heightForDetailsLabelFromAttributedString(attributedString) + chartHeight
            }
            return 0.0
        }
        return heightForDetailsLabelFromAttributedString(attributedString) + chartHeight
    }
    
    func heightForDetailsLabelFromAttributedString(attributedString: NSAttributedString) -> CGFloat {
        
        return  ceil(attributedString.boundingRectWithSize(CGSize(width: tableView.frame.width - 62, height: CGFloat.max), options:[.UsesFontLeading,.UsesLineFragmentOrigin]  ,context: nil).height) + (45 + 35)
    }
    


    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier("DemoHeaderView") as? DemoHeaderView
        if let facebookID = data?["facebook-id"] as? String {
            view?.setFacebookUserID(facebookID)
        }
        if let name = data?["name"] as? String, position = data?["position"] as? String {
            view?.setName(name, position: position)
        }
        tmpTopConstraint = view?.visualEffectViewTopConstraint
        return view
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            tmpTopConstraint?.constant = scrollView.contentOffset.y
        }else{
            tmpTopConstraint?.constant = 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

}

class DemoCell: UITableViewCell {
    
    @IBOutlet var topLine: UIView!
    @IBOutlet var bottomLine: UIView!
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    @IBOutlet weak var indentHeight: NSLayoutConstraint!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
   
    @IBOutlet weak var radarChartView: UIView!
    
    @IBOutlet weak var chartWidthConst: NSLayoutConstraint!
    
    override func drawRect(rect: CGRect) {

        let lineHeight = 1.0 / UIScreen.mainScreen().scale
        indentHeight.constant = lineHeight
        separatorHeight.constant = lineHeight
        
    }
    
    static func attributeForTitle() -> [String:AnyObject] {
        return [NSFontAttributeName:UIFont(name: "HelveticaNeue-Medium", size: 14)!,NSKernAttributeName:3]
    }
    
    static func attributeForDetails() -> [String:AnyObject] {
        return [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 13)!,NSForegroundColorAttributeName:UIColor(hue:0.64, saturation:0.04, brightness:0.61, alpha:1)]
    }
    
    func setChart(data: [String:Int]?) {
        
        for view in radarChartView.subviews {
            view.removeFromSuperview()
        }

        guard let _data = data else {
            chartWidthConst.constant = 0
            return
        }
        

        chartWidthConst.constant = 200
        
        let chartView = RadarChartView(frame: CGRect(origin: CGPoint.zero, size: radarChartView.frame.size))
        chartView.legend.enabled = false
        let xAxis = chartView.xAxis
        xAxis.labelFont = UIFont(name: "HelveticaNeue", size: 10)!
        xAxis.labelTextColor = UIColor(hue:0.64, saturation:0.04, brightness:0.61, alpha:1)
        
        let yAxis = chartView.yAxis
        yAxis.drawLabelsEnabled = false
        
        chartView.descriptionText = ""
        
        radarChartView.addSubview(chartView)
        chartView.makeEdgesEqualTo(radarChartView)
        
        var chartData = [ChartDataEntry]()
        var cols = [String]()
        var index:Int = 0
        for each in _data {
            chartData.append(ChartDataEntry(value: Double(each.1), xIndex: index++))
            cols.append(each.0)
        }
        
        let set = RadarChartDataSet(yVals: chartData)
        set.setColor(UIColor(hue:0.64, saturation:0.04, brightness:0.61, alpha:1))
        set.drawVerticalHighlightIndicatorEnabled = false
        set.drawFilledEnabled = true
        set.lineWidth = 1
        set.drawValuesEnabled = false

        let dat = RadarChartData(xVals: cols, dataSet: set)
        
        dat.setValueTextColor(UIColor.clearColor())
        
        chartView.data = dat
        
    }
    
}
