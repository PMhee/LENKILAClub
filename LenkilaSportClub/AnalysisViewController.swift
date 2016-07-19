//
//  AnalysisViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 6/25/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Charts
class AnalysisViewController: UIViewController,UIGestureRecognizerDelegate,UIScrollViewDelegate,ChartViewDelegate {
    
    var graph_date_enable = false
    @IBOutlet weak var lb_description: UILabel!
    var slot = [Double?]()
    var slot_date = [Double?]()
    var last_time_month : Int! = nil
    @IBOutlet weak var vw_graph: LineChartView!
    @IBAction func btn_consult_lenkila(sender: UIButton) {
    }
    @IBOutlet weak var lb_customer_play_price: UILabel!
    @IBOutlet weak var lb_customer_telephone: UILabel!
    @IBOutlet weak var lb_customer_play_time: UILabel!
    @IBOutlet weak var lb_customer_nick_name: UILabel!
    @IBOutlet weak var lb_customer_name: UILabel!
    @IBOutlet weak var lb_customer_year: UILabel!
    @IBOutlet weak var lb_customer_month: UILabel!
    @IBOutlet weak var lb_customer_today_lastyear: UILabel!
    @IBOutlet weak var lb_customer_today: UILabel!
    @IBOutlet weak var lb_income_year: UILabel!
    @IBOutlet weak var lb_income_month: UILabel!
    @IBOutlet weak var lb_income_today_lastyear: UILabel!
    @IBOutlet weak var lb_income_today: UILabel!
    var best_customer = [String:Int]()
    var count_month = [String:Int]()
    @IBAction func btn_graph_date_action(sender: UIButton) {
        btn_graph_date.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
        btn_graph_time.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1.0)
        graph_date_enable = true
        let hours = ["9", "10", "11", "12", "13", "14","15","16","17","18","19","20","21","22","23","24"]
        var play = [Double]()
        for i in 0..<slot.count{
            play.append(slot[i]!)
        }
        let date = ["จันทร์","อังคาร","พุธ","พฤหัสบดี","ศุกร์","เสาร์","อาทิตย์"]
        var play_date = [Double]()
        for i in 0..<slot_date.count{
            play_date.append(slot_date[i]!)
        }
        if !graph_date_enable{
            setChart(hours, values: play)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละชั่วโมงใน 1 เดือน"
        }else{
            setChartDate(date, values: play_date)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละวันใน 1 เดือน"
        }
    }
    @IBAction func btn_graph_time_action(sender: UIButton) {
        btn_graph_date.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1.0)
        btn_graph_time.backgroundColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
        graph_date_enable = false
        let hours = ["9", "10", "11", "12", "13", "14","15","16","17","18","19","20","21","22","23","24"]
        var play = [Double]()
        for i in 0..<slot.count{
            play.append(slot[i]!)
        }
        let date = ["จันทร์","อังคาร","พุธ","พฤหัสบดี","ศุกร์","เสาร์","อาทิตย์"]
        var play_date = [Double]()
        for i in 0..<slot_date.count{
            play_date.append(slot_date[i]!)
        }
        if !graph_date_enable{
            setChart(hours, values: play)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละชั่วโมงใน 1 เดือน"
        }else{
            setChartDate(date, values: play_date)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละวันใน 1 เดือน"
        }
    }
    @IBAction func btn_more_detail(sender: UIButton) {
        self.performSegueWithIdentifier("more_detail", sender: self)
    }
    @IBAction func btn_more_details(sender: UIButton) {
        self.performSegueWithIdentifier("more_detail", sender: self)
    }
    
    @IBOutlet weak var btn_graph_date: UIButton!
    @IBOutlet weak var btn_graph_time: UIButton!
    @IBOutlet weak var lb_show_play_count: UILabel!
    @IBOutlet weak var lb_show_income: UILabel!
    @IBOutlet weak var img_best_customer: UIImageView!
    var x :CGFloat = 0
    var y :CGFloat = 0
    var enable_touch : Bool = false
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    @IBOutlet weak var cons_tab_width: NSLayoutConstraint!
    var tab_trigger : Bool = false
    @IBAction func btn_tab_action(sender: UIButton) {
        trigger_tab()
    }
    var sum_count : Int = 0
    @IBOutlet weak var vw_show_money: UIView!
    @IBOutlet weak var vw_show_reserve: UIView!
    @IBOutlet weak var vw_show_graph: UIView!
    @IBOutlet weak var sv_main: UIScrollView!
    @IBOutlet weak var btn_contact: UIButton!
    @IBOutlet weak var btn_today: UIButton!
    var userArray = [User]()
    var scheduleArray = [Schedule]()
    var sortedDate = [Int]()
    @IBAction func btn_today_action(sender: UIButton) {
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        lb_date.text = format.stringFromDate(NSDate())
        gatherAllData()
        sortSchedule()
        for i in 0..<scheduleArray.count {
            sortedDate.append(createSortDate(scheduleArray[i].date))
        }
        genSlot()
        let hours = ["9", "10", "11", "12", "13", "14","15","16","17","18","19","20","21","22","23","24"]
        var play = [Double]()
        for i in 0..<slot.count{
            play.append(slot[i]!)
        }
        let date = ["จันทร์","อังคาร","พุธ","พฤหัสบดี","ศุกร์","เสาร์","อาทิตย์"]
        var play_date = [Double]()
        for i in 0..<slot_date.count{
            play_date.append(slot_date[i]!)
        }
        if !graph_date_enable{
            setChart(hours, values: play)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละชั่วโมงใน 1 เดือน"
        }else{
            setChartDate(date, values: play_date)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละวันใน 1 เดือน"
        }
        generateAll()
    }
    @IBOutlet weak var vw_compare_stat: UIView!
    @IBAction func btn_right_action(sender: UIButton) {
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        lb_date.text = format.stringFromDate(format.dateFromString(lb_date.text!)!.dateByAddingTimeInterval(60*60*24))
        gatherAllData()
        sortSchedule()
        for i in 0..<scheduleArray.count {
            sortedDate.append(createSortDate(scheduleArray[i].date))
        }
        genSlot()
        let hours = ["9", "10", "11", "12", "13", "14","15","16","17","18","19","20","21","22","23","24"]
        var play = [Double]()
        for i in 0..<slot.count{
            play.append(slot[i]!)
        }
        let date = ["จันทร์","อังคาร","พุธ","พฤหัสบดี","ศุกร์","เสาร์","อาทิตย์"]
        var play_date = [Double]()
        for i in 0..<slot_date.count{
            play_date.append(slot_date[i]!)
        }
        if !graph_date_enable{
            setChart(hours, values: play)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละชั่วโมงใน 1 เดือน"
        }else{
            setChartDate(date, values: play_date)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละวันใน 1 เดือน"
        }
        generateAll()
    }
    @IBAction func btn_left_action(sender: UIButton) {
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        lb_date.text = format.stringFromDate(format.dateFromString(lb_date.text!)!.dateByAddingTimeInterval(-60*60*24))
        gatherAllData()
        sortSchedule()
        for i in 0..<scheduleArray.count {
            sortedDate.append(createSortDate(scheduleArray[i].date))
        }
        genSlot()
        let hours = ["9", "10", "11", "12", "13", "14","15","16","17","18","19","20","21","22","23","24"]
        var play = [Double]()
        for i in 0..<slot.count{
            play.append(slot[i]!)
        }
        let date = ["จันทร์","อังคาร","พุธ","พฤหัสบดี","ศุกร์","เสาร์","อาทิตย์"]
        var play_date = [Double]()
        for i in 0..<slot_date.count{
            play_date.append(slot_date[i]!)
        }
        if !graph_date_enable{
            setChart(hours, values: play)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละชั่วโมงใน 1 เดือน"
        }else{
            setChartDate(date, values: play_date)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละวันใน 1 เดือน"
        }
        generateAll()
    }
    @IBOutlet weak var lb_date: UILabel!
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    func trigger_tab(){
        var count = 0.0
        if !tab_trigger{
            //self.UserDetailTableView.userInteractionEnabled = false
            while(count <= 0.25){
                delay(count){
                    self.cons_tab_width.constant += self.view.frame.width/13
                }
                count += 0.025
            }
        }else{
            //self.UserDetailTableView.userInteractionEnabled = true
            while(count <= 0.25){
                delay(count){
                    self.cons_tab_width.constant -= self.view.frame.width/13
                }
                count += 0.025
            }
            
        }
        tab_trigger = !tab_trigger
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        lb_date.text = format.stringFromDate(NSDate())
        btn_today.layer.cornerRadius = 15
        btn_today.layer.masksToBounds = true
        self.tap_gesture.delegate = self
        self.view.addGestureRecognizer(tap_gesture)
        sv_main.delegate = self
        img_best_customer.layer.cornerRadius = 70
        img_best_customer.layer.masksToBounds = true
        btn_contact.layer.cornerRadius = 10
        btn_contact.layer.masksToBounds = true
        vw_show_graph.layer.cornerRadius = 5
        vw_show_graph.layer.masksToBounds = true
        vw_show_money.layer.cornerRadius  = 5
        vw_show_money.layer.masksToBounds = true
        vw_show_reserve.layer.cornerRadius = 5
        vw_show_reserve.layer.masksToBounds = true
        vw_compare_stat.layer.cornerRadius = 5
        vw_compare_stat.layer.masksToBounds = true
        vw_graph.delegate = self
        vw_graph.descriptionText = ""
        vw_graph.descriptionTextColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        vw_graph.infoTextColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        vw_graph.drawMarkers = false
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        gatherAllData()
        sortSchedule()
        for i in 0..<scheduleArray.count {
            sortedDate.append(createSortDate(scheduleArray[i].date))
        }
        genSlot()
        let hours = ["9", "10", "11", "12", "13", "14","15","16","17","18","19","20","21","22","23","24"]
        var play = [Double]()
        for i in 0..<slot.count{
            play.append(slot[i]!)
        }
        let date = ["จันทร์","อังคาร","พุธ","พฤหัสบดี","ศุกร์","เสาร์","อาทิตย์"]
        var play_date = [Double]()
        for i in 0..<slot_date.count{
            play_date.append(slot_date[i]!)
        }
        if !graph_date_enable{
            setChart(hours, values: play)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละชั่วโมงใน 1 เดือน"
        }else{
            setChartDate(date, values: play_date)
            lb_description.text = "สถิติจำนวนครั้งที่ถูกจองแต่ละวันใน 1 เดือน"
        }
        generateAll()
        
    }
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartDataSet.valueFont = UIFont(name: "ThaiSansLite", size: 10)!
        vw_graph.data = lineChartData
        var colors: [UIColor] = []
        for i in 0..<dataPoints.count {
            let color = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
            colors.append(color)
        }
        var colors2: [UIColor] = []
        for i in 0..<dataPoints.count {
            colors2.append(UIColor(red:0,green: 0,blue: 0,alpha: 1.0))
        }
        lineChartDataSet.circleRadius = 3
        lineChartDataSet.circleColors = colors
        lineChartDataSet.colors = colors2
    }
    func setChartDate(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartDataSet.valueFont = UIFont(name: "ThaiSansLite", size: 10)!
        vw_graph.data = lineChartData
        var colors: [UIColor] = []
        for i in 0..<dataPoints.count {
            let color = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
            colors.append(color)
        }
        var colors2: [UIColor] = []
        for i in 0..<dataPoints.count {
            colors2.append(UIColor(red:0,green: 0,blue: 0,alpha: 1.0))
        }
        lineChartDataSet.circleRadius = 3
        lineChartDataSet.circleColors = colors
        lineChartDataSet.colors = colors2
    }
    func sortSchedule(){
        scheduleArray.sortInPlace({$0.sort_date < $1.sort_date})
    }
    func generateAll(){
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        let numberFormatter = NSNumberFormatter()
        numberFormatter.internationalCurrencySymbol = ""
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
        lb_show_income.text = numberFormatter.stringFromNumber(calDayMoneyIncome(self.lb_date.text!) as NSNumber)! + " บาท"
        lb_show_play_count.text = String(sum_count)
        lb_income_today.text = numberFormatter.stringFromNumber(calDayMoneyIncome(self.lb_date.text!) as NSNumber)!
        lb_customer_today.text = String(sum_count)
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([.Day , .Month , .Year], fromDate: dateFormat.dateFromString(self.lb_date.text!)!)
        var day = components.day
        var month = components.month
        var year = components.year
        dateFormat.dateFormat = "mm/dd/yyyy"
        year -= 1
        let current = dateFormat.dateFromString(String(month)+"/"+String(day)+"/"+String(year))
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        let today_last_year = dateFormat.stringFromDate(current!)
        if calDayMoneyIncome(today_last_year) > calDayMoneyIncome(self.lb_date.text!) {
            lb_income_today_lastyear.textColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
        }else{
            lb_income_today_lastyear.textColor = UIColor(red: 112/255, green: 181/255, blue: 69/255, alpha: 1.0)
        }
        lb_income_today_lastyear.text = numberFormatter.stringFromNumber(calDayMoneyIncome(today_last_year) as NSNumber)
        lb_customer_today_lastyear.text = String(sum_count)
        year += 1
        var sumy : Double = 0.0
        var sumCounty : Int = 0
        var sum : Double = 0.0
        var sumCount : Int = 0
        if scheduleArray.count > 0 {
            for i in 0..<scheduleArray.count{
                components = calendar.components([.Day , .Month , .Year], fromDate: dateFormat.dateFromString(scheduleArray[i].date)!)
                let m = components.month
                let y = components.year
                if y == year {
                    if m == month {
                        sum += scheduleArray[i].price
                        sumCount += 1
                        sumy += scheduleArray[i].price
                        sumCounty += 1
                    }else if m < month{
                        sumy += scheduleArray[i].price
                        sumCounty += 1
                    }else if m > month{
                        sumy += scheduleArray[i].price
                        sumCounty += 1
                    }
                }else if y > year{
                    break
                }else{
                    
                }
            }
        }
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let dat = calendar.dateFromComponents(dateComponents)!
        let rge = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: dat)
        let numDays = rge.length
        sum = sum/Double(numDays)
        if sum > calDayMoneyIncome(self.lb_date.text!) {
            lb_income_month.textColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
        }else{
            lb_income_month.textColor = UIColor(red: 112/255, green: 181/255, blue: 69/255, alpha: 1.0)
        }
        lb_income_month.text = numberFormatter.stringFromNumber(sum as NSNumber)
        lb_customer_month.text = String(sumCount)
        var date_in_year : Int = 0
        if year%4 == 0 {
            date_in_year = 366
        }else{
            date_in_year = 355
        }
        sumy = sumy/Double(date_in_year)
        if sumy > calDayMoneyIncome(self.lb_date.text!) {
            lb_income_year.textColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
        }else{
            lb_income_year.textColor = UIColor(red: 112/255, green: 181/255, blue: 69/255, alpha: 1.0)
        }
        lb_income_year.text = numberFormatter.stringFromNumber(sumy as NSNumber)
        lb_customer_year.text = String(sumCounty)
        findBestCustomer()
    }
    func calDayMoneyIncome(date:String) -> Double{
        var idx = -1
        if sortedDate.count > 0 {
            idx = binarySearch(sortedDate, searchItem: createSortDate(date))
        }
        var sum : Double = 0.0
        sum_count = 0
        if idx != -1 {
            if scheduleArray.count > 0 {
                for i in idx..<scheduleArray.count{
                    if scheduleArray[i].date == date && scheduleArray[i].already_paid{
                        sum += scheduleArray[i].price
                        self.sum_count += 1
                    }else{
                        break
                    }
                }
            }
        }
        return sum
    }
    func binarySearch<T:Comparable>(inputArr:Array<T>, searchItem: T)->Int{
        var lowerIndex = 0
        var upperIndex = inputArr.count - 1
        while (true) {
            let currentIndex = (lowerIndex + upperIndex)/2
            if(inputArr[currentIndex] == searchItem) {
                if currentIndex != 0 {
                    if inputArr[currentIndex-1] == searchItem{
                        upperIndex = currentIndex - 1
                    }else{
                        return currentIndex
                    }
                }else{
                    return 0
                }
            } else if (lowerIndex > upperIndex) {
                return -1
            } else {
                if (inputArr[currentIndex] > searchItem) {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }
    func gatherAllData(){
        userArray = [User]()
        scheduleArray = [Schedule]()
        sortedDate = [Int]()
        let user = User.allObjects()
        if user.count > 0 {
            for i in 0..<user.count{
                userArray.append(user[i] as! User)
            }
        }
        let schedule = Schedule.allObjects()
        if schedule.count > 0 {
            for i in 0..<schedule.count{
                let sche = schedule[i] as! Schedule
                if sche.already_paid {
                    scheduleArray.append(schedule[i] as! Schedule)
                    
                }
                
            }
        }
        
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if tab_trigger {
            x = touch.locationInView(self.view).x
            y = touch.locationInView(self.view).y
            if x > self.view.frame.width * 11 / 13 {
                enable_touch = !enable_touch
            }
            return true
        }else{
            return false
        }
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if enable_touch {
            self.trigger_tab()
            enable_touch = !enable_touch
            return true
        }else{
            return false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //        if (scrollView.contentOffset.y != 0) {
        //            var offset:CGPoint = scrollView.contentOffset
        //            offset.y = 0
        //            scrollView.contentOffset = offset
        //        }
        var offset:CGPoint = scrollView.contentOffset
        
        if (scrollView.contentOffset.y == -64){
            offset.y = 0
            scrollView.contentOffset = offset
        }
        if (scrollView.contentOffset.x != 0) {
            
            offset.x = 0
            scrollView.contentOffset = offset        }
    }
    func createSortDate(date:String)->Int{
        let dateFormatt = NSDateFormatter()
        dateFormatt.dateStyle = NSDateFormatterStyle.FullStyle
        dateFormatt.dateFromString(date)
        let formatt = NSDateFormatter()
        formatt.dateStyle = NSDateFormatterStyle.ShortStyle
        var d = formatt.stringFromDate(dateFormatt.dateFromString(date)!)
        var range = d.rangeOfString("/")!
        var index = d.startIndex.distanceTo(range.startIndex)
        var month = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(0), end: d.startIndex.advancedBy(index)))
        d = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(index+1), end: d.endIndex.advancedBy(0)))
        range = d.rangeOfString("/")!
        index = d.startIndex.distanceTo(range.startIndex)
        if month.characters.count == 1 {
            month = "0"+month
        }
        var day = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(0), end: d.startIndex.advancedBy(index)))
        if day.characters.count == 1 {
            day = "0"+day
        }
        var year = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(index+1), end: d.endIndex.advancedBy(0)))
        if year.characters.count > 4 {
            var range: Range<String.Index> = year.rangeOfString(" ")!
            var index: Int = year.startIndex.distanceTo(range.startIndex)
            year = year.substringWithRange(Range<String.Index>(start: year.startIndex.advancedBy(0), end: year.startIndex.advancedBy(index)))
        }

        return Int(year+month+day)!
    }
    func findBestCustomer(){
        best_customer = [String:Int]()
        let numberFormatter = NSNumberFormatter()
        numberFormatter.internationalCurrencySymbol = ""
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([.Day , .Month , .Year], fromDate: dateFormat.dateFromString(self.lb_date.text!)!)
        var day = components.day
        var month = components.month
        var year = components.year
        if scheduleArray.count > 0 {
            for i in 0..<scheduleArray.count{
                components = calendar.components([.Day , .Month , .Year], fromDate: dateFormat.dateFromString(scheduleArray[i].date)!)
                let m = components.month
                if m == month {
                    if best_customer[scheduleArray[i].userID] == nil {
                        best_customer[scheduleArray[i].userID] = 1
                    }else{
                        best_customer[scheduleArray[i].userID]! += 1
                    }
                }else if m > month {
                    break
                }else{
                    
                }
            }
        }
        var max = 0
        var idx = ""
        if best_customer.count > 0 {
            for i in 0..<best_customer.count{
                let index = best_customer.startIndex.advancedBy(i)
                if max < best_customer[best_customer.keys[index]]! {
                    max = best_customer[best_customer.keys[index]]!
                    idx = best_customer.keys[index]
                }
            }
        }
        if max != 0 {
            if userArray[Int(idx)!].name == " " {
                lb_customer_name.text = "ไม่มีข้อมูล"
            }else{
                lb_customer_name.text = userArray[Int(idx)!].name
            }
            lb_customer_nick_name.text = userArray[Int(idx)!].nickName
            lb_customer_play_time.text = String(max) + " ครั้ง"
            if userArray[Int(idx)!].contact == " "{
                lb_customer_telephone.text = "ไม่มีข้อมูล"
            }else{
                lb_customer_telephone.text = userArray[Int(idx)!].contact
            }
            lb_customer_play_price.text = numberFormatter.stringFromNumber(userArray[Int(idx)!].price as NSNumber)
        }else{
            lb_customer_name.text = "ไม่มีข้อมูล"
            lb_customer_nick_name.text = "ไม่มีข้อมูล"
            lb_customer_play_time.text = "ไม่มีข้อมูล"
            lb_customer_telephone.text = "ไม่มีข้อมูล"
            lb_customer_play_price.text = "ไม่มีข้อมูล"
        }
    }
    func genSlot(){
        slot = [Double?](count: 16, repeatedValue: nil)
        slot_date = [Double?](count:7,repeatedValue:nil)
        for i in 0..<slot_date.count{
            slot_date[i] = 0
        }
        for i in 0...slot.count-1{
            slot[i] = 0
        }
        if scheduleArray.count > 0 {
            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
            let calendar = NSCalendar.currentCalendar()
            var components = calendar.components([.Day , .Month , .Year], fromDate: dateFormat.dateFromString(self.lb_date.text!)!)
            var day = components.day
            var month = components.month
            var year = components.year
            for i in 0...scheduleArray.count-1 {
                components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: dateFormat.dateFromString(scheduleArray[i].date)!)
                let m = components.month
                let y = components.year
                var wd = components.weekday
                if y == year {
                if m == month {
                    var a : String = self.scheduleArray[i].time
                    var range: Range<String.Index> = a.rangeOfString(".")!
                    var index: Int = a.startIndex.distanceTo(range.startIndex)
                    let startHour = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(0), end: a.startIndex.advancedBy(index)))
                    range = a.rangeOfString(" ")!
                    let index1 = a.startIndex.distanceTo(range.startIndex)
                    var startMin = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(index+1), end: (a.startIndex.advancedBy(index1))))
                    a = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(index1+3), end: (a.endIndex.advancedBy(0))))
                    range = a.rangeOfString(".")!
                    let index2 = a.startIndex.distanceTo(range.startIndex)
                    let endHour = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(0), end: (a.startIndex.advancedBy(index2))))
                    var endMin = a.substringWithRange(Range<String.Index>(start: a.startIndex.advancedBy(index2+1), end: (a.endIndex.advancedBy(0))))
                    let first = ((Int(startHour)!-8))
                    let second = (Int(endHour)!-9)
                    for j in first...second {
                        slot[j]! += 1
                    }
                    wd -= 2
                    if wd == -1 {
                        wd = 6
                    }
                    slot_date[wd]! += 1
                }else if m>month{
                    break
                }else{
                    
                }
                }else if y > year {
                    break
                }else{
                    continue
                }
                
            }
        }
    }

            /*
             // MARK: - Navigation
             
             // In a storyboard-based application, you will often want to do a little preparation before navigation
             override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
             // Get the new view controller using segue.destinationViewController.
             // Pass the selected object to the new view controller.
             }
             */
            
}
