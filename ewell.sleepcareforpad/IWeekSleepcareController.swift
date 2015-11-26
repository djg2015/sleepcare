//
//  IWeekSleepcareController.swift
//
//
//  Created by djg on 15/11/25.
//
//

import UIKit

class IWeekSleepcareController: UIViewController {
    @IBOutlet weak var svSleep: UIScrollView!
    @IBOutlet weak var btnBack: UIButton!
    let height1:CGFloat = 167
    let height2:CGFloat = 83
    let height3:CGFloat = 135
    let height4:CGFloat = 60
    let height5:CGFloat = 200
    let height6:CGFloat = 140
    let height7:CGFloat = 250
    var uione = UIView()
    var uitwo = UIView()
    var uithree = UIView()
    var uifour = UIView()
    var uifive = UIView()
    var uisix = UIView()
    var uiseven = UIView()
    var lblTitle = UILabel()
    var bedUserCode:String!
    var sleepDate:String!
    
    required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?,bedusercode:String,searchdate:String) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.bedUserCode = bedusercode
        self.sleepDate = searchdate
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置滚动区域7个区域元素
        var screenWidth = UIScreen.mainScreen().bounds.width
        self.svSleep.contentSize = CGSize(width: screenWidth, height: (height1+height2+height3+height4+height5+height6+height7))
        self.lblTitle.text = "2015-10-11~2015-10-17"
        self.lblTitle.textColor = UIColor.grayColor()
        self.lblTitle.frame = CGRectMake((screenWidth/2 - 95), 3, 190, 30)
        self.svSleep.addSubview(lblTitle)
        
        self.uione.frame = CGRectMake(0, 33, screenWidth, height1)
        self.uione.backgroundColor = UIColor.clearColor()
    
        self.uione.layer.contents = UIImage(named: "garyboxback.png")?.CGImage
        self.svSleep.addSubview(uione)
        
        self.uitwo.frame = CGRectMake(0, height1+33, screenWidth, height2)
        self.uitwo.backgroundColor = UIColor.whiteColor()
        self.svSleep.addSubview(uitwo)
        
        self.uithree.frame = CGRectMake(0, height1 + height2+33, screenWidth, height3)
        self.uithree.backgroundColor = UIColor.clearColor()
        self.uithree.layer.contents = UIImage(named: "garyboxback.png")?.CGImage
        self.svSleep.addSubview(uithree)
        
        self.uifour.frame = CGRectMake(0, height1 + height2 + height3+33, screenWidth, height4)
        self.uifour.backgroundColor = UIColor.whiteColor()
        self.svSleep.addSubview(uifour)
        
        self.uifive.frame = CGRectMake(0, height1 + height2 + height3 + height4+33, screenWidth, height5)
        self.uifive.backgroundColor = UIColor.clearColor()
        self.uifive.layer.contents = UIImage(named: "garyboxback.png")?.CGImage
        self.svSleep.addSubview(uifive)
        
        self.uisix.frame = CGRectMake(0, height1 + height2 + height3 + height4 + height5+33, screenWidth, height6)
        self.uisix.backgroundColor = UIColor.whiteColor()
        self.svSleep.addSubview(uisix)
        
        self.uiseven.frame = CGRectMake(0, height1 + height2 + height3 + height4 + height5 + height6+33, screenWidth, height7)
        self.uiseven.backgroundColor = UIColor.lightGrayColor()
        self.svSleep.addSubview(uiseven)
        
        self.btnBack!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.dismissViewControllerAnimated(true, completion: nil)
                
        }
        
        Loaddata()
        
    }
    
    //加载初始数据
    func Loaddata(){
        //查询底层数据
        var sleepCareForIPhoneBussinessManager = BusinessFactory<SleepCareForIPhoneBussinessManager>.GetBusinessInstance("SleepCareForIPhoneBussinessManager")
        var weekReport:IWeekReport = sleepCareForIPhoneBussinessManager.GetWeekReportByUser(self.bedUserCode, reportDate: self.sleepDate)
        
        //设置7个区域显示
        //区域1
        Setchart1()
        
        //区域2
        var label2_1 = UILabel()
        label2_1.text = "周最大心率:"
        label2_1.font = label2_1.font.fontWithSize(15)
        label2_1.frame = CGRectMake(10, 5, 80, 20)
        self.uitwo.addSubview(label2_1)
        
        var label2_2 = UILabel()
        label2_2.text = "33次/分"
        label2_2.font = label2_2.font.fontWithSize(15)
        label2_2.frame = CGRectMake(95, 5, 60, 20)
        self.uitwo.addSubview(label2_2)
        
        var label2_3 = UILabel()
        label2_3.text = "周最快呼吸:"
        label2_3.font = label2_3.font.fontWithSize(15)
        label2_3.frame = CGRectMake(165, 5, 80, 20)
        self.uitwo.addSubview(label2_3)
        
        var label2_4 = UILabel()
        label2_4.text = "33次/分"
        label2_4.font = label2_4.font.fontWithSize(15)
        label2_4.frame = CGRectMake(250, 5, 60, 20)
        self.uitwo.addSubview(label2_4)
        
        var label2_5 = UILabel()
        label2_5.text = "周最小心率:"
        label2_5.font = label2_5.font.fontWithSize(15)
        label2_5.frame = CGRectMake(10, 25, 80, 20)
        self.uitwo.addSubview(label2_5)
        
        var label2_6 = UILabel()
        label2_6.text = "33次/分"
        label2_6.font = label2_6.font.fontWithSize(15)
        label2_6.frame = CGRectMake(95, 25, 60, 20)
        self.uitwo.addSubview(label2_6)
        
        var label2_7 = UILabel()
        label2_7.text = "周最慢呼吸:"
        label2_7.font = label2_7.font.fontWithSize(15)
        label2_7.frame = CGRectMake(165, 25, 80, 20)
        self.uitwo.addSubview(label2_7)
        
        var label2_8 = UILabel()
        label2_8.text = "33次/分"
        label2_8.font = label2_8.font.fontWithSize(15)
        label2_8.frame = CGRectMake(250, 25, 60, 20)
        self.uitwo.addSubview(label2_8)
        
        var label2_9 = UILabel()
        label2_9.text = "周平均心率:"
        label2_9.font = label2_9.font.fontWithSize(15)
        label2_9.frame = CGRectMake(10, 45, 80, 20)
        self.uitwo.addSubview(label2_9)
        
        var label2_10 = UILabel()
        label2_10.text = "33次/分"
        label2_10.font = label2_10.font.fontWithSize(15)
        label2_10.frame = CGRectMake(95, 45, 60, 20)
        self.uitwo.addSubview(label2_10)
        
        var label2_11 = UILabel()
        label2_11.text = "周平均呼吸:"
        label2_11.font = label2_11.font.fontWithSize(15)
        label2_11.frame = CGRectMake(165, 45, 80, 20)
        self.uitwo.addSubview(label2_11)
        
        var label2_12 = UILabel()
        label2_12.text = "33次/分"
        label2_12.font = label2_12.font.fontWithSize(15)
        label2_12.frame = CGRectMake(250, 45, 60, 20)
        self.uitwo.addSubview(label2_12)
        
        //区域3
        Setchart3()

        //区域4
        var label4_1 = UILabel()
        label4_1.text = "离床频繁"
        label4_1.font = label2_12.font.fontWithSize(15)
        label4_1.frame = CGRectMake(10, 10, 60, 20)
        self.uifour.addSubview(label4_1)
        
        var label4_2 = UILabel()
        label4_2.text = "一，四"
        label4_2.font = label4_2.font.fontWithSize(15)
        label4_2.frame = CGRectMake(80, 10, 200, 20)
        self.uifour.addSubview(label4_2)
        
        //区域5
        
        
        //区域6
        var label6_1 = UILabel()
        label6_1.text = "睡眠时长"
        label6_1.font = label6_1.font.fontWithSize(15)
        label6_1.frame = CGRectMake(15, 5, 60, 20)
        self.uisix.addSubview(label6_1)
        
        var label6_2 = UILabel()
        label6_2.text = "深睡时长"
        label6_2.font = label6_2.font.fontWithSize(15)
        label6_2.frame = CGRectMake(120, 5, 60, 20)
        self.uisix.addSubview(label6_2)
        
        var label6_3 = UILabel()
        label6_3.text = "潜睡时长"
        label6_3.font = label6_3.font.fontWithSize(15)
        label6_3.frame = CGRectMake(225, 5, 60, 20)
        self.uisix.addSubview(label6_3)
        
        var label6_4 = UILabel()
        label6_4.text = "6小时38分"
        label6_4.font = label6_4.font.fontWithSize(17)
        label6_4.frame = CGRectMake(10, 27, 100, 20)
        self.uisix.addSubview(label6_4)
        
        var label6_5 = UILabel()
        label6_5.text = "6小时38分"
        label6_5.font = label6_5.font.fontWithSize(17)
        label6_5.frame = CGRectMake(115, 27, 100, 20)
        self.uisix.addSubview(label6_5)
        
        var label6_6 = UILabel()
        label6_6.text = "6小时38分"
        label6_6.font = label6_6.font.fontWithSize(17)
        label6_6.frame = CGRectMake(220, 27, 100, 20)
        self.uisix.addSubview(label6_6)
        
        var label6_7 = UILabel()
        label6_7.text = "上床时间"
        label6_7.font = label6_7.font.fontWithSize(15)
        label6_7.frame = CGRectMake(15, 60, 60, 20)
        self.uisix.addSubview(label6_7)
        
        var label6_8 = UILabel()
        label6_8.text = "起床时间"
        label6_8.font = label6_8.font.fontWithSize(15)
        label6_8.frame = CGRectMake(120, 60, 60, 20)
        self.uisix.addSubview(label6_8)
        
        var label6_9 = UILabel()
        label6_9.text = "清醒时长"
        label6_9.font = label6_9.font.fontWithSize(15)
        label6_9.frame = CGRectMake(225, 60, 60, 20)
        self.uisix.addSubview(label6_9)
        
        var label6_10 = UILabel()
        label6_10.text = "下午11:40"
        label6_10.font = label6_10.font.fontWithSize(17)
        label6_10.frame = CGRectMake(10, 82, 100, 20)
        self.uisix.addSubview(label6_10)
        
        var label6_11 = UILabel()
        label6_11.text = "上午9:30"
        label6_11.font = label6_11.font.fontWithSize(17)
        label6_11.frame = CGRectMake(115, 82, 100, 20)
        self.uisix.addSubview(label6_11)
        
        var label6_12 = UILabel()
        label6_12.text = "6小时38分"
        label6_12.font = label6_12.font.fontWithSize(17)
        label6_12.frame = CGRectMake(220, 82, 100, 20)
        self.uisix.addSubview(label6_12)
        
        //区域7
        var label7_1 = UILabel()
        label7_1.text = "睡眠建议"
        label7_1.font = UIFont.boldSystemFontOfSize(17)
        label7_1.frame = CGRectMake(10, 5, 100, 20)
        self.uiseven.addSubview(label7_1)
        
        var label7_2 = UILabel()
        label7_2.text = "离床次数"
        label7_2.font = label7_2.font.fontWithSize(15)
        label7_2.frame = CGRectMake(13, 30, 60, 20)
        self.uiseven.addSubview(label7_2)
        
        var label7_3 = UILabel()
        label7_3.text = "3次"
        label7_3.font = label7_3.font.fontWithSize(15)
        label7_3.frame = CGRectMake(80, 30, 60, 20)
        self.uiseven.addSubview(label7_3)
        
        var label7_4 = UILabel()
        label7_4.text = "最高离床时间"
        label7_4.font = label7_4.font.fontWithSize(15)
        label7_4.frame = CGRectMake(150, 30, 90, 20)
        self.uiseven.addSubview(label7_4)
        
        var label7_5 = UILabel()
        label7_5.text = "3小时40分钟"
        label7_5.font = label7_5.font.fontWithSize(15)
        label7_5.frame = CGRectMake(247, 30, 90, 20)
        self.uiseven.addSubview(label7_5)
        
        var label7_6 = UILabel()
        label7_6.text = "翻身次数"
        label7_6.font = label7_6.font.fontWithSize(15)
        label7_6.frame = CGRectMake(13, 55, 60, 20)
        self.uiseven.addSubview(label7_6)
        
        var label7_7 = UILabel()
        label7_7.text = "3次"
        label7_7.font = label7_7.font.fontWithSize(15)
        label7_7.frame = CGRectMake(80, 55, 60, 20)
        self.uiseven.addSubview(label7_7)
        
        var label7_8 = UILabel()
        label7_8.text = "翻身频率"
        label7_8.font = label7_8.font.fontWithSize(15)
        label7_8.frame = CGRectMake(150, 55, 60, 20)
        self.uiseven.addSubview(label7_8)
        
        var label7_9 = UILabel()
        label7_9.text = "低"
        label7_9.font = label7_9.font.fontWithSize(15)
        label7_9.frame = CGRectMake(217, 55, 80, 20)
        self.uiseven.addSubview(label7_9)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Setchart1(){
        //设置心率曲线
        var data01Array: [CGFloat] = []
        for(var i = 6;i >= 0;i--){
            data01Array.append(20)
        }
        var data01:PNLineChartData = PNLineChartData()
        data01.color = UIColor.magentaColor()
        data01.itemCount = UInt(data01Array.count)
        data01.dataTitle = "心率"
        data01.getData = ({(index: UInt)  in
            var yValue:CGFloat = data01Array[Int(index)]
            var item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        //设置呼吸曲线
        var data02Array: [CGFloat] = []
        for(var i = 6 ;i >= 0;i--){
            data02Array.append(5)
        }
        var data02:PNLineChartData = PNLineChartData()
        data02.color = PNGreenColor
        data02.itemCount = UInt(data02Array.count)
        data02.dataTitle = "呼吸"
        data02.getData = ({(index: UInt)  in
            var yValue:CGFloat = data02Array[Int(index)]
            var item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        var lineChart:PNLineChart? = PNLineChart(frame: CGRectMake(0, 10, self.uione.frame.width - 10, self.uione.frame.height))
        lineChart!.yLabelFormat = "%1.1f"
        lineChart!.yFixedValueMin = 0
        lineChart!.showLabel = true
        lineChart!.backgroundColor = UIColor.clearColor()
        lineChart!.xLabels = []
        for(var i = 6 ;i >= 0;i--){
            //            var xlable = self.SignReports![i].ReportHour.subString(11, length: 2)
            //            if(xlable.hasPrefix("0")){
            //                xlable = xlable.subString(1, length: 1)
            //            }
            //            xlable = xlable + "点"
            lineChart!.xLabels.append("日")
        }
        //lineChart.xLabels = ["08:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00"]
        lineChart!.showCoordinateAxis = true
        
        
        lineChart!.chartData = [data01,data02]
        lineChart!.strokeChart()
        self.uione.addSubview(lineChart!)
        
        
        lineChart!.legendStyle = PNLegendItemStyle.Serial
        let legend = lineChart!.getLegendWithMaxWidth(self.uione.frame.width)
        legend.frame = CGRectMake(80, 3, self.uione.frame.width, self.uione.frame.height)
        self.uione.addSubview(legend)
        
        
    }
    
    func Setchart3(){
        //设置心率曲线
        var data01Array: [CGFloat] = []
        for(var i = 6;i >= 0;i--){
            data01Array.append(20)
        }
        var data01:PNLineChartData = PNLineChartData()
        data01.color = UIColor.redColor()
        data01.itemCount = UInt(data01Array.count)
        data01.dataTitle = "离床"
        data01.getData = ({(index: UInt)  in
            var yValue:CGFloat = data01Array[Int(index)]
            var item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        
        var lineChart:PNLineChart? = PNLineChart(frame: CGRectMake(0, 10, self.uithree.frame.width - 10, self.uithree.frame.height))
//        lineChart!.yLabelFormat = "%1.1f"
//        lineChart!.yFixedValueMin = 0
//        lineChart!.showLabel = true
        lineChart!.backgroundColor = UIColor.clearColor()
        lineChart!.xLabels = []
        for(var i = 6 ;i >= 0;i--){
            //            var xlable = self.SignReports![i].ReportHour.subString(11, length: 2)
            //            if(xlable.hasPrefix("0")){
            //                xlable = xlable.subString(1, length: 1)
            //            }
            //            xlable = xlable + "点"
            lineChart!.xLabels.append("日")
        }
        //lineChart.xLabels = ["08:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00","09:00"]
        lineChart!.showCoordinateAxis = true
        
        
        lineChart!.chartData = [data01]
        lineChart!.strokeChart()
        self.uithree.addSubview(lineChart!)
        
        
        lineChart!.legendStyle = PNLegendItemStyle.Serial
        let legend = lineChart!.getLegendWithMaxWidth(self.uithree.frame.width)
        legend.frame = CGRectMake(self.uithree.frame.width - 65, 3, self.uithree.frame.width, self.uithree.frame.height)
        self.uithree.addSubview(legend)
        
        
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
