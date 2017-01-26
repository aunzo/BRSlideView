import UIKit

import BRSlideView

class ViewController: UIViewController {
    
    let titleArray = ["page1", "page2", "page3", "page4", "page5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sliderView = BRSlideView(frame: self.view.bounds)
        sliderView.delegate = self
        sliderView.dataSource = self
        sliderView.setSlideBarHeight(height: 3)
        self.view.addSubview(sliderView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: BRSlideViewDelegate
{
    func slideView(slideView: BRSlideView, didSelectItemAt index: Int) {
        print(index)
    }
}

extension ViewController: BRSlideViewDataSource
{
    func numberOfSlideItems(in slideView: BRSlideView) -> Int {
        return self.titleArray.count
    }
    
    func slideView(_ slideView: BRSlideView, titleForSlideItemsAt index: Int) -> String? {
        
        return self.titleArray[index]
    }
    
    func slideView(_ slideView: BRSlideView, viewControllerAt index: Int) -> UIViewController {
        let subVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubVC") as! SubViewController
        
        subVC.titleStr = "page \(index + 1)"
        
        return subVC
    }
}
