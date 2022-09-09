import UIKit
import JitsiMeetSDK

class JitsiMeetViewController: UIViewController {
  var conferenceOptions: JitsiMeetConferenceOptions?
  var resolver: RCTPromiseResolveBlock?
  var jitsiMeetView = JitsiMeetView()

  override func viewDidLoad() {
    
    jitsiMeetView.join(conferenceOptions)
    jitsiMeetView.delegate = self
    
    view = jitsiMeetView
  }
}

extension JitsiMeetViewController: JitsiMeetViewDelegate {
  func ready(toClose data: [AnyHashable : Any]!) {
    DispatchQueue.main.async {
        let rootViewController = UIApplication.shared.delegate?.window??.rootViewController as! UINavigationController
        rootViewController.popViewController(animated: false)
    }
      
    if ((resolver) != nil) {
      resolver!([])
    }
  }
}

extension JitsiMeetViewController {
  // This is needed to avoid the React Native view behind it, to be hit by touch events.=
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
}