import {
  DeviceEventEmitter,
  NativeEventEmitter,
  NativeModules,
  Platform,
} from 'react-native';
import type { JitsiMeetType, JitsiMeetEventType } from './types';

const { RNJitsiMeet } = NativeModules;

const eventEmitter = Platform.select({
  ios: new NativeEventEmitter(RNJitsiMeet),
  android: DeviceEventEmitter,
});

export default RNJitsiMeet as JitsiMeetType;

type EventListener = (event: JitsiMeetEventType) => void;

class JitsiMeetEventListener {
  private listeners: EventListener[] = [];

  constructor() {
    eventEmitter?.addListener("onJitsiMeetConference", this.onEventHandler);
  }

  private onEventHandler = (event: JitsiMeetEventType) => {
    this.listeners.forEach((listener) => {
      listener(event);
    })
  }

  addEventListener(listener: EventListener) {
    // Prevent duplication
    this.removeEventListener(listener);

    this.listeners.push(listener)

    return () => {
      this.removeEventListener(listener);
    }
  }

  removeEventListener(listener: EventListener) {
    this.listeners = this.listeners.filter((listnr) => listnr !== listener);
  }
}

export const JitsiMeetEvent = new JitsiMeetEventListener();
