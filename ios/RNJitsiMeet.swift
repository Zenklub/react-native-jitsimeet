import UIKit
import JitsiMeetSDK

@objc(RNJitsiMeet)
class RNJitsiMeet: RCTEventEmitter {

    override init() {
        super.init()
        EventEmitter.sharedInstance.registerEventEmitter(eventEmitter: self)
    }
    
    @objc func hangUp(resolver resolve: @escaping RCTPromiseResolveBlock,
                      rejecter reject: @escaping RCTPromiseRejectBlock) {
 
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController as? RNJitsiMeetViewController else {
            reject("LAUNCH_JITSI", "rootViewController should be RNJitsiMeetViewController", NSError())
            return
        }
        
        rootViewController.hangUp()
        resolve(nil)

    }

    @objc func launchJitsiMeetView(_ options: NSDictionary,
                                   resolver resolve: @escaping RCTPromiseResolveBlock,
                                   rejecter reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            do {
                guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController as? RNJitsiMeetViewController else {
                    return reject("LAUNCH_JITSI", "rootViewController should be RNJitsiMeetViewController", NSError())
                }
                
                try rootViewController.openJitsiMeet(with: options)
                resolve(nil)
            } catch RNJitsiMeetError.missingRoom {
                return reject("MISSING_ROOM", "You must provide a room", RNJitsiMeetError.missingRoom)
            } catch {
                return reject("LAUNCH_JITSI", error.localizedDescription, error)
                
            }
        }
    }

    @objc func launch(_ options: NSDictionary, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        launchJitsiMeetView(options, resolver: resolve, rejecter: reject)
    }
    
    @objc open override func supportedEvents() -> [String] {
        return EventEmitter.sharedInstance.allEvents
    }
}
