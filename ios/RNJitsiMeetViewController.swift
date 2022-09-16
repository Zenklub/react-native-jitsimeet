//
//  JitsiMeetViewController.swift
//  react-native-jitsimeet
//
//  Created by Erick on 14/09/22.
//

import UIKit
import JitsiMeetSDK

enum RNJitsiMeetError: Error {
    case missingRoom
}

protocol RNJitsiMeetViewDelegate {
    
}

@objc(RNJitsiMeetViewController)
class RNJitsiMeetViewController: UIViewController {
    fileprivate var conferenceOptions: JitsiMeetConferenceOptions?
    fileprivate var jitsiMeetView: JitsiMeetView?
    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    fileprivate var delegate: RNJitsiMeetViewDelegate?
    
    @objc var rnView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let rnView = rnView else {
            print("[RNJitsieet]: rnView was not set")
            return
        }
        
        view.addSubview(rnView)
        
    }
    
    fileprivate func cleanUp() {
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
        pipViewCoordinator = nil
    }
    
    func hangUp() {
        jitsiMeetView?.hangUp()
        cleanUp()
    }
    
    func openJitsiMeet(with options: NSDictionary) throws {
        conferenceOptions = RNJitsiMeetUtil.buildConferenceOptions(options)
        if conferenceOptions?.room == nil {
            throw RNJitsiMeetError.missingRoom
        }
        
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        
        // join room and display jitsi-call
        jitsiMeetView.join(conferenceOptions!)
        
        // Enable jitsimeet view to be a view that can be displayed
        // on top of all the things, and let the coordinator to manage
        // the view state and interactions
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: view)

        // animate in
        jitsiMeetView.alpha = 0
        pipViewCoordinator?.show()
    }
    
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let rect = CGRect(origin: CGPoint.zero, size: size)
        // Reset view to provide bounds. It is required to do so
        // on rotation or screen size changes.
        pipViewCoordinator?.resetBounds(bounds: rect)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rnView?.frame = self.view.bounds
    }
    
}

extension RNJitsiMeetViewController: JitsiMeetViewDelegate {
    
    func ready(toClose data: [AnyHashable : Any]!) {
        self.pipViewCoordinator?.hide() { _ in
            self.cleanUp()
        }
        EventEmitter.sharedInstance.dispatch(event: .readyToClose, body: data)
    }
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        self.pipViewCoordinator?.enterPictureInPicture()
        EventEmitter.sharedInstance.dispatch(event: .enterPictureInPicture, body: data)
    }
    
    /**
     * Called when a conference was joined.
     *
     * The `data` dictionary contains a `url` key with the conference URL.
     */
    func conferenceJoined(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .conferenceJoined, body: data)
    }

    /**
     * Called when the active conference ends, be it because of user choice or
     * because of a failure.
     *
     * The `data` dictionary contains an `error` key with the error and a `url` key
     * with the conference URL. If the conference finished gracefully no `error`
     * key will be present. The possible values for "error" are described here:
     * https://github.com/jitsi/lib-jitsi-meet/blob/master/JitsiConnectionErrors.ts
     * https://github.com/jitsi/lib-jitsi-meet/blob/master/JitsiConferenceErrors.ts
     */
    func conferenceTerminated(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .conferenceTerminated, body: data)
    }

    /**
     * Called before a conference is joined.
     *
     * The `data` dictionary contains a `url` key with the conference URL.
     */
    func conferenceWillJoin(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .conferenceWillJoin, body: data)
    }

    /**
     * Called when entering Picture-in-Picture is requested by the user. The app
     * should now activate its Picture-in-Picture implementation (and resize the
     * associated `JitsiMeetView`. The latter will automatically detect its new size
     * and adjust its user interface to a variant appropriate for the small size
     * ordinarily associated with Picture-in-Picture.)
     *
     * The `data` dictionary is empty.
     */
    func enterPictureInPicture(data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .enterPictureInPicture, body: data)
    }

    /**
     * Called when a participant has joined the conference.
     *
     * The `data` dictionary contains a `participantId` key with the id of the participant that has joined.
     */
    func participantJoined(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .participantJoined, body: data)
    }

    /**
     * Called when a participant has left the conference.
     *
     * The `data` dictionary contains a `participantId` key with the id of the participant that has left.
     */
    func participantLeft(data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .participantLeft, body: data)
    }

    /**
     * Called when audioMuted state changed.
     *
     * The `data` dictionary contains a `muted` key with state of the audioMuted for the localParticipant.
     */
    func audioMutedChanged(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .audioMutedChanged, body: data)
    }

    /**
     * Called when an endpoint text message is received.
     *
     * The `data` dictionary contains a `senderId` key with the participantId of the sender and a 'message' key with the content.
     */
    func endpointTextMessageReceived(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .endpointTextMessageReceived, body: data)
    }

    /**
     * Called when a participant toggled shared screen.
     *
     * The `data` dictionary contains a `participantId` key with the id of the participant  and a 'sharing' key with boolean value.
     */
    func screenShareToggled(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .screenShareToggled, body: data)
    }

    /**
     * Called when a chat message is received.
     *
     * The `data` dictionary contains `message`, `senderId` and  `isPrivate` keys.
     */
    func chatMessageReceived(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .chatMessageReceived, body: data)
    }

    /**
     * Called when the chat dialog is displayed/hidden.
     *
     * The `data` dictionary contains a `isOpen` key.
     */
    func chatToggled(data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .chatToggled, body: data)
    }

    /**
     * Called when videoMuted state changed.
     *
     * The `data` dictionary contains a `muted` key with state of the videoMuted for the localParticipant.
     */
    func videoMutedChanged(_ data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .videoMutedChanged, body: data)
    }

    /**
     * Called when the SDK is ready to be closed. No meeting is happening at this point.
     */
    func readyToClose(data: [AnyHashable : Any]) {
        EventEmitter.sharedInstance.dispatch(event: .readyToClose, body: data)
        
    }
}

