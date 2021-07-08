//
//  AnalyseResultVC.swift
//  apple
//
//  Created by admin on 2021/7/8.
//

import UIKit
import Charts
import SnapKit
import UGSwiftKit

 class AnalyseChartsView: UIView{

    
    override init(frame: CGRect) {
        super .init(frame: frame)
        makeUI()
        makeLaout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    var delegate:ChartViewDelegate?{
        set{
            kChartView.delegate = newValue
        }
        get{
            kChartView.delegate
        }
    }
    
    var kdata:[Daily] = []{
        didSet{
            
            kChartView.notifyDataSetChanged()
        }
    }
    var bsPoints:[BSModen] = []{
        didSet{
            kChartView.notifyDataSetChanged()
        }
    }
 
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.backgroundColor = .red
        return scrollView
    }()
    
    lazy var kChartView: CombinedChartView = {
        let kChartView = CombinedChartView()
        kChartView.backgroundColor = .yellow
        return kChartView
    }()


}

extension AnalyseChartsView{
    func makeUI()  {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(kChartView)
    }
    func makeLaout() {
      
   
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.snp.makeConstraints { snp in
            snp.edges.equalTo(self)
        }
        kChartView.snp.remakeConstraints{ snp in
            snp.top.equalTo(scrollView).offset(20)
            snp.height.equalTo(300)
            snp.width.equalTo(scrollView)
            
        }
        self.snp.makeConstraints { snp in
            snp.edges.equalTo(0)
        }
    }
    
}
