//
//  ViewController.swift
//  ipadcacl
//
//  Created by 谭钧豪 on 16/2/21.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var remarkTable: UITableView!
    var resultf:UITextField!
    var process:UILabel!
    //备注储存
    var resultsz = NSMutableArray()
    var tempnums = NSMutableArray()
    //计算器区域
    var caclleftx:CGFloat!
    var cacltopy:CGFloat!
    var bigRs:UILabel!
    //临时储存数字
    var tempnumber:Double = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainscreen = UIScreen.mainScreen().bounds
        if let rs = NSUserDefaults.standardUserDefaults().valueForKey("results"){
            if rs.count != 0 {
                resultsz = NSMutableArray(array: rs as! [AnyObject], copyItems: true)
            }
        }
        
        caclleftx = remarkTable.frame.width + remarkTable.frame.origin.x + 10
        cacltopy = 68
        let numpadx:CGFloat = 450
        
        resultf = UITextField(frame: CGRectMake(caclleftx,cacltopy,mainscreen.width - remarkTable.frame.width - 140,100))
        resultf.font = UIFont.boldSystemFontOfSize(50)
        resultf.keyboardType = .NumberPad
        resultf.textAlignment = .Right
        resultf.text = "0"
        
        process = UILabel(frame: CGRectMake(caclleftx,cacltopy+110,mainscreen.width - remarkTable.frame.width - 20,50))
        process.text = ""
        
        
        
        
        let deletebtn = UIButton(type: .System)
        deletebtn.setTitle("回删", forState: .Normal)
        deletebtn.titleLabel?.font = UIFont.systemFontOfSize(25)
        deletebtn.tintColor = UIColor.whiteColor()
        deletebtn.backgroundColor = UIColor.redColor()
        deletebtn.frame = CGRectMake(mainscreen.width - 120,cacltopy + 5,100,40)
        deletebtn.layer.cornerRadius = 10
        deletebtn.addTarget(self, action: Selector("deletenum"), forControlEvents: .TouchDown)
        let longdelete = UILongPressGestureRecognizer(target: self, action: Selector("continuedelete"))
        longdelete.minimumPressDuration = 1
        deletebtn.addGestureRecognizer(longdelete)

        //数字键盘区域所有按钮
        let numpady:CGFloat = 128
        for i in 1...9{
            let numbtn = UIButton(type: .System)
            numbtn.titleLabel?.textAlignment = .Center
            numbtn.titleLabel?.font = UIFont.boldSystemFontOfSize(50)
            numbtn.setTitle("\(i)", forState: .Normal)
            numbtn.layer.borderWidth = 0.5
            numbtn.layer.borderColor = UIColor.blackColor().CGColor
            numbtn.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1)
            numbtn.tag = i
            numbtn.frame = CGRectMake(self.view.frame.width - numpadx + CGFloat((i-1)%3)*(100+10), numpady + CGFloat((1-i)/3)*110 + 330, 110, 110)
            numbtn.addTarget(self, action: Selector("numtap:"), forControlEvents: .TouchUpInside)
            self.view.addSubview(numbtn)
        }
        let numbtn0 = UIButton(type: .System)
        numbtn0.titleLabel?.textAlignment = .Left
        numbtn0.titleLabel?.font = UIFont.boldSystemFontOfSize(50)
        numbtn0.setTitle("0", forState: .Normal)
        numbtn0.layer.borderWidth = 0.5
        numbtn0.layer.borderColor = UIColor.blackColor().CGColor
        numbtn0.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1)
        numbtn0.tag = 0
        numbtn0.frame = CGRectMake(self.view.frame.width - numpadx, numpady + 440, 220, 110)
        numbtn0.addTarget(self, action: Selector("numtap:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(numbtn0)
        let numbtnd = UIButton(type: .System)
        numbtnd.titleLabel?.textAlignment = .Center
        numbtnd.titleLabel?.font = UIFont.boldSystemFontOfSize(50)
        numbtnd.setTitle(".", forState: .Normal)
        numbtnd.layer.borderWidth = 0.5
        numbtnd.layer.borderColor = UIColor.blackColor().CGColor
        numbtnd.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1)
        numbtnd.tag = 10
        numbtnd.frame = CGRectMake(self.view.frame.width - numpadx + CGFloat(220), numpady + 440, 110, 110)
        numbtnd.addTarget(self, action: Selector("numtap:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(numbtnd)
        for i in 11...14{
            var caclm = ""
            switch i{
            case 11:caclm = "➕"
            case 12:caclm = "➖"
            case 13:caclm = "✖️"
            case 14:caclm = "➗"
            default:print("不会进这里")
            }
            let numbtnm = UIButton(type: .System)
            numbtnm.titleLabel?.textAlignment = .Center
            numbtnm.titleLabel?.font = UIFont.boldSystemFontOfSize(50)
            numbtnm.setTitle(caclm, forState: .Normal)
            numbtnm.layer.borderWidth = 0.5
            numbtnm.layer.borderColor = UIColor.blackColor().CGColor
            numbtnm.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1)
            numbtnm.tag = i
            numbtnm.frame = CGRectMake(self.view.frame.width - numpadx + CGFloat(330), numpady + 110*CGFloat(i-10), 110, 110)
            numbtnm.addTarget(self, action: Selector("numtap:"), forControlEvents: .TouchUpInside)
            self.view.addSubview(numbtnm)
        }
        let collectbtn = UIButton(type: .System)
        collectbtn.titleLabel?.textAlignment = .Center
        collectbtn.titleLabel?.font = UIFont.boldSystemFontOfSize(70)
        collectbtn.setTitle("=", forState: .Normal)
        collectbtn.tintColor = UIColor.blackColor()
        collectbtn.layer.borderWidth = 0.5
        collectbtn.layer.borderColor = UIColor.blackColor().CGColor
        collectbtn.backgroundColor = UIColor.orangeColor()
        collectbtn.tag = 15
        collectbtn.frame = CGRectMake(self.view.frame.width - numpadx + CGFloat(220), numpady + 550, 220, 80)
        collectbtn.addTarget(self, action: Selector("numtap:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(collectbtn)
        let clearbtn = UIButton(type: .System)
        clearbtn.titleLabel?.textAlignment = .Center
        clearbtn.titleLabel?.font = UIFont.boldSystemFontOfSize(50)
        clearbtn.setTitle("清空", forState: .Normal)
        clearbtn.tintColor = UIColor.whiteColor()
        clearbtn.layer.borderWidth = 0.5
        clearbtn.layer.borderColor = UIColor.blackColor().CGColor
        clearbtn.backgroundColor = UIColor.redColor()
        clearbtn.frame = CGRectMake(self.view.frame.width - numpadx, numpady + 550, 220, 80)
        clearbtn.addTarget(self, action: Selector("clear"), forControlEvents: .TouchUpInside)
        let addbtn = UIButton(type: .System)
        addbtn.setTitle("为结果添加备注", forState: .Normal)
        addbtn.titleLabel?.font = UIFont.systemFontOfSize(25)
        addbtn.tintColor = UIColor.whiteColor()
        addbtn.backgroundColor = UIColor(red:0, green:0.57, blue:1, alpha:1)
        addbtn.frame = CGRectMake(caclleftx,numpady + 330,200,40)
        addbtn.layer.cornerRadius = 10
        addbtn.addTarget(self, action: Selector("add"), forControlEvents: .TouchUpInside)
        
        //大结果显示框
        let bigRstips = UILabel(frame: CGRectMake(caclleftx, numpady+110, 440, 110))
        bigRstips.text = "最终结果："
        bigRstips.font = UIFont.boldSystemFontOfSize(30)
        bigRs = UILabel(frame: CGRectMake(caclleftx, numpady+220, 440, 110))
        bigRs.font = UIFont.boldSystemFontOfSize(40)
        bigRs.text = "0"
        
        
        resultf.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(bigRstips)
        self.view.addSubview(bigRs)
        self.view.addSubview(addbtn)
        self.view.addSubview(deletebtn)
        self.view.addSubview(process)
        self.view.addSubview(resultf)
        self.view.addSubview(clearbtn)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func clear(){
        resultf.text = "0"
        process.text = ""
        tempnumber = 0
    }
    
    var unchangestr = ""
    func numtap(sender:UIButton){
        if sender.tag < 10{
            resultf.text = resultf.text! + "\(sender.tag)"
            if resultf.text!.characters.first == "0" && !resultf.text!.hasPrefix("0."){
                resultf.text! = "\(sender.tag)"
            }else if resultf.text!.hasPrefix("0."){
                
            }
            iftf3()
            let tempstr = resultf.text!
            realtimestr(tempstr, unchangestr: unchangestr)
        }else{
            if sender.tag != 10{
                if resultf.text!.characters.last == "."{
                    resultf.text = String(resultf.text!.characters.dropLast())
                }
            }
            process.text = delcomma(process.text!)
            switch(sender.tag){
            case 10:
                if resultf.text!.characters.count == 0{
                    resultf.text = "0."
                }else if !resultf.text!.characters.contains("."){
                    resultf.text = resultf.text! + "."
                }
            case 11:
                numaddminus("+")
            case 12:
                numaddminus("-")
            case 13:
                numaddminus("x")
            case 14:
                numaddminus("/")
            //括号形态算法(未添加)
//            case 16:
//                if let i = process.text?.characters.last{
//                    let ii = String(i)
//                    if ii == "+" || ii == "-" || ii == "x" || ii == "/"{
//                        unchangestr = process.text! + "("
//                        process.text = unchangestr
//                    }
//                }else if process.text!.characters.count == 0{
//                    unchangestr = process.text! + "("
//                    process.text = unchangestr
//                }
//                parenthesestatu = true
//                
//            case 17:
//                if process.text!.characters.contains("("){
//                    if let i = process.text?.characters.last{
//                        let ii = String(i)
//                        if ii != "+" && ii != "-" && ii != "x" && ii != "/"{
//                            unchangestr = process.text! + ")"
//                            process.text = unchangestr
//                        }
//                    }
//                }
//                parenthesestatu = false
            default:
                print("=")
                if process.text != ""{
                    changesymbol()
                    rsequal()
                }else{

                }
            }
            
        }
    }
    
    func changesymbol(){
        if process.text!.characters.last == "+" || process.text!.characters.last == "-" || process.text!.characters.last == "x" || process.text!.characters.last == "/"{
            process.text = String(process.text!.characters.dropLast())
        }else{
        }
    }
    
    func rsequal(){
        numaddminus("+")
        process.text = String(process.text!.characters.dropLast())
        bigRs.text = String(format: "%.4f",Double(process.text!)!)
        unchangestr = process.text!
        resultf.text = process.text!
    }
    
    func realtimestr(tempstr:String,unchangestr:String){
        if let tn = Double(resultf.text!){
            tempnumber = tn
            resultf.placeholder = ducenum(tn)
        }else{
            resultf.placeholder = ""
        }
        process.text = unchangestr + tempstr
    }
    
    func aftercacl(method:String){
        resultf.text = delcomma(resultf.text!)
        if resultf.text != ""{
            process.text = process.text! + method
            unchangestr = process.text!
            resultf.placeholder = resultf.text!
            tempnumber = Double(resultf.text!)!
            resultf.text = ""
        }else{
            process.text = String(process.text!.characters.dropLast())
            process.text = process.text! + method
            unchangestr = process.text!
        }
    }
    
    func numaddminus(method:String){
        if method == "/" && tempnumber == 0{
            let warn = UIAlertController(title: "提醒", message: "被除数不能为0", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "好的", style: .Default, handler: nil)
            warn.addAction(ok)
            presentViewController(warn, animated: true, completion: nil)
            return
        }
        
        if process.text!.characters.contains("x"){
            var lastcaclindex:String.Index
            if var addindex = process.text!.characters.indexOf("+"){
                addindex = addindex.advancedBy(1)
                if var minusindex = process.text!.characters.indexOf("-"){
                    minusindex = minusindex.advancedBy(1)
                    lastcaclindex = minusindex > addindex ? minusindex : addindex
                }else{
                    lastcaclindex = addindex
                }
                let tmpstr = process.text!.substringFromIndex(lastcaclindex)
                let tmparr = tmpstr.characters.split("x")
                let mulrs = Double(String(tmparr[0]))!*Double(String(tmparr[1]))!
                process.text = process.text!.substringToIndex(lastcaclindex) + ducenum(mulrs)
            }else if var minusindex = process.text!.characters.indexOf("-"){
                    minusindex = minusindex.advancedBy(1)
                    lastcaclindex = minusindex
                    let tmpstr = process.text!.substringFromIndex(lastcaclindex)
                    let tmparr = tmpstr.characters.split("x")
                    let mulrs = Double(String(tmparr[0]))!*Double(String(tmparr[1]))!
                    process.text = process.text!.substringToIndex(lastcaclindex) + ducenum(mulrs)
            }else{
                let tmparr = process.text!.characters.split("x")
                let mulrs = Double(String(tmparr[0]))!*Double(String(tmparr[1]))!
                process.text = ducenum(mulrs)
            }
        }else if process.text!.characters.contains("/"){
            var lastcaclindex:String.Index
            if var addindex = process.text!.characters.indexOf("+"){
                addindex = addindex.advancedBy(1)
                if var minusindex = process.text!.characters.indexOf("-"){
                    minusindex = minusindex.advancedBy(1)
                    lastcaclindex = minusindex > addindex ? minusindex : addindex
                }else{
                    lastcaclindex = addindex
                }
                let tmpstr = process.text!.substringFromIndex(lastcaclindex)
                let tmparr = tmpstr.characters.split("/")
                let mulrs = Double(String(tmparr[0]))!/Double(String(tmparr[1]))!
                process.text = process.text!.substringToIndex(lastcaclindex) + ducenum(mulrs)
            }else if var minusindex = process.text!.characters.indexOf("-"){
                minusindex = minusindex.advancedBy(1)
                lastcaclindex = minusindex
                let tmpstr = process.text!.substringFromIndex(lastcaclindex)
                let tmparr = tmpstr.characters.split("/")
                let mulrs = Double(String(tmparr[0]))!/Double(String(tmparr[1]))!
                process.text = process.text!.substringToIndex(lastcaclindex) + ducenum(mulrs)
            }else{
                let tmparr = process.text!.characters.split("/")
                let mulrs = Double(String(tmparr[0]))!/Double(String(tmparr[1]))!
                process.text = ducenum(mulrs)
            }
        }
        if process.text!.characters.contains("+") && method != "x" && method != "/"{
            let tmparr = process.text!.characters.split("+")
            let mulrs = Double(String(tmparr[0]))!+Double(String(tmparr[1]))!
            process.text = ducenum(mulrs)
        }else if process.text!.characters.contains("-") && method != "x" && method != "/"{
            let tmparr = process.text!.characters.split("-")
            let mulrs = Double(String(tmparr[0]))!-Double(String(tmparr[1]))!
            process.text = ducenum(mulrs)
        }
        aftercacl(method)
    }
    
    
    func ducenum(num:Double) -> String{
        if "\(num)".hasSuffix(".0"){
            return "\(num)".substringToIndex("\(num)".endIndex.advancedBy(-2))
        }else{
            return "\(num)"
        }
    }
    

    //整数位3位加逗号
    func iftf3(){
        //防止最后一位是小数点时调用
        if resultf.text!.characters.last != "." && resultf.text!.characters.count != 0{
            //将整数与小数部分分隔开
            let resultfarr = resultf.text!.characters.split(".")
            var afterpoint = ""
            if resultfarr.count > 1{
                afterpoint = "." + String(resultfarr[1])
                resultf.text = String(resultfarr[0])
            }
            //移除先前添加的逗号再计算
            resultf.text =  resultf.text!.stringByReplacingOccurrencesOfString(",", withString: "")
            //数字超3位再开始添加以防在第一位直接添加逗号
            if resultf.text!.characters.count > 3{
                //3位循环向数字中插入逗号
                let price = (resultf.text!.characters.count-1)/3
                for i in 1...price{
                    if i != 1{
                        resultf.text!.insert(",", atIndex: resultf.text!.characters.endIndex.advancedBy(1 - 4 * i))
                    }else{
                        resultf.text!.insert(",", atIndex: resultf.text!.characters.endIndex.advancedBy(-3))

                    }
                }
            }
            //整合整数部分与小数部分
            resultf.text = resultf.text! + afterpoint
        }
        
    }
    
    //删除逗号
    func delcomma(str:String) ->String{
        return str.stringByReplacingOccurrencesOfString(",", withString: "")
    }
    
    //添加备注
    func add(){
        let alert = UIAlertController(title: "提示", message: "请输入备注信息", preferredStyle: .Alert)
        let okaction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: {
            (UIAlertAction) -> Void in
            let remark = alert.textFields![0].text
            self.tempnums.addObject(self.bigRs.text!)
            let rss = NSMutableDictionary()
            rss.addEntriesFromDictionary([remark!:self.tempnums])
            self.resultsz.addObject(rss)
            NSUserDefaults.standardUserDefaults().setValue(self.resultsz, forKey: "results")
            self.remarkTable.reloadData()
        })
        alert.addTextFieldWithConfigurationHandler { (textfield) -> Void in
            textfield.placeholder = "备注"
        }
        alert.addAction(okaction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //回删数字
    func deletenum() {
        var temptxt = resultf.text! as NSString
        if !resultf.text!.characters.isEmpty{
            temptxt = temptxt.substringToIndex(temptxt.length - 1)
            resultf.text = temptxt as String
            iftf3()
        }else if process.text?.characters.count != 0{
            unchangestr = String(unchangestr.characters.dropLast())
            process.text = String(process.text!.characters.dropLast())
            resultf.text = temptxt as String
            iftf3()
        }
    }
    
    //长按清空上方数字
    func continuedelete(){
        resultf.text = ""
    }
    
    
    
    //左侧备注TableView设置
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsz.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var celltxt = resultsz[indexPath.row].allKeys[0] as? String
        celltxt = celltxt! + " : " + (resultsz[indexPath.row][celltxt!]!!.lastObject as? String)!
        
        cell.textLabel?.text = celltxt
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        resultsz.removeObjectAtIndex(indexPath.row)
        NSUserDefaults.standardUserDefaults().setValue(resultsz, forKey: "results")
        tableView.reloadData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        resultf.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

