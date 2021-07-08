//
//  AnalyseResultVC.swift
//  apple
//
//  Created by admin on 2021/7/8.
//

import UIKit
import Charts
import SnapKit

class AnalyseResultVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        makeLaout()
    }
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.backgroundColor = .red
        return scrollView
    }()
    lazy var kChartView: CombinedChartView = {
        let kChartView = CombinedChartView()
        return kChartView
    }()

    
  

}

extension AnalyseResultVC{
    func makeUI()  {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(kChartView)
    }
    func makeLaout() {
        scrollView.snp.makeConstraints { snp in
            snp.edges.equalTo(0)
        }
        
    }
}
