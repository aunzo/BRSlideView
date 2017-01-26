import UIKit

class SubViewController: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!
    var titleStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TitleLabel.text = titleStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
