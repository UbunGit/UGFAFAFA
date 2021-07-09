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
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    lazy var kChartView: CombinedChartView = {
        let kChartView = CombinedChartView()
    
        return kChartView
    }()
    
    lazy var amountChartView: BarChartView = {
        let amountChartView = BarChartView()

        return amountChartView
    }()


}

extension AnalyseChartsView{
    func makeUI()  {
  
        addSubview(kChartView)
        addSubview(amountChartView)
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
     
        kChartView.snp.remakeConstraints{ snp in
            snp.top.equalTo(self).offset(0)
            snp.height.equalTo(self).multipliedBy(0.7)
            snp.width.equalTo(self)
            
        }
        amountChartView.snp.remakeConstraints{ snp in
            snp.top.equalTo(kChartView.snp.bottom).offset(0)
            snp.height.equalTo(self).multipliedBy(0.3)
            snp.width.equalTo(self)
            
        }
        self.snp.makeConstraints { snp in
            snp.edges.equalTo(0)
        }
    }
    
}
