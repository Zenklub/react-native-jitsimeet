//
//  EventEmitter.swift
//  RNJitsiMeet
//
//  Created by Erick on 15/09/22.
//

import Foundation


enum Events: String, CaseIterable {
    case conferenceStart = "conference-start"
    case conferenceJoined = "conference-joined"
    case conferenceTerminated = "conference-terminated"
    case conferenceWillJoin = "conference-will-join"
    case enterPictureInPicture = "enter-pip"
    case participantJoined = "participant-joined"
    case participantLeft = "participant-left"
    case endpointTextMessageReceived = "endpoint-text-message-received"
    case screenShareToggled = "screen-share-toggled"
    case chatMessageReceived = "chat-message-received"
    case chatToggled = "chat-toggled"
    case audioMutedChanged = "audio-muted-change"
    case videoMutedChanged = "video-muted-change"
    case readyToClose = "ready-to-close"
    
    static var allEvents: [String] {
        return Events.allCases.map { $0.rawValue }
    }
}

class EventEmitter {
    
    /// Shared Instance.
    public static var sharedInstance = EventEmitter()

    // ReactNativeEventEmitter is instantiated by React Native with the bridge.
    private var eventEmitter: RNJitsiMeet!

    private init() {}

    // When React Native instantiates the emitter it is registered here.
    func registerEventEmitter(eventEmitter: RNJitsiMeet) {
        self.eventEmitter = eventEmitter
    }

    func dispatch(event: Events, body: Any?) {
        eventEmitter.sendEvent(
            withName: "onJitsiMeetConference",
            body: [
                "type": event.rawValue,
                "data": body
            ]
        )
    }

    /// All Events which must be support by React Native.
    lazy var allEvents: [String] = {
        return Events.allEvents
    }()

}
