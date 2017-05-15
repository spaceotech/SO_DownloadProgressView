
import UIKit

class ViewController: UIViewController,ProgressViewDelegate {

    //MARK:- IBOutlet -
    @IBOutlet var progressView: ProgressView!
    
    //MARK:- ViewLifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         Set the animation style for progressView and font of the text 
 **/
        progressView.animationStyle = kCAMediaTimingFunctionLinear
        progressView.font = UIFont.systemFont(ofSize: 17)
        
        progressView.delegate = self
        progressView.isUserInteractionEnabled  = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.startTheProgress(gesture:)))
        self.progressView.addGestureRecognizer(tapgesture)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func startTheProgress(gesture:UITapGestureRecognizer)
    {
        self.progressView.animationStyle = kCAMediaTimingFunctionLinear
        self.progressView.setProgress(value: 100, animationDuration: 5, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- ProgressViewDelegate method -
    func finishedProgress(forCircle circle: ProgressView) {
     if circle == progressView{
        print("completed progress")
        }
    }
}

