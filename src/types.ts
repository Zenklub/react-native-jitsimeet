export interface JitsiMeetUserInfo {
  displayName?: string;
  email?: string;
  avatar?: string;
}

export interface JitsiMeetConferenceOptions {
  room: string;
  serverUrl?: string;
  userInfo?: JitsiMeetUserInfo;
  token?: string;
  subject?: string;
  audioOnly?: boolean;
  audioMuted?: boolean;
  videoMuted?: boolean;
  featureFlags?: { [key: string]: boolean };
}

interface Event<T extends string, D extends object> {
  type: T;
  data: D;
}

export type JitsiMeetEventType =
  | Event<'conference-start', { url: string }>
  | Event<'conference-joined', { url: string }>
  | Event<'conference-terminated', { url: string; error?: string }>
  | Event<'conference-will-join', { url: string }>
  | Event<'enter-pip', {}>
  | Event<'participant-joined', { participantId: string; email: string; name: string; role: string; }>
  | Event<'participant-left', { participantId: string }>
  | Event<
      'endpoint-text-message-received',
      { senderId: string; message: string }
    >
  | Event<'screen-share-toggled', { participantId: string; sharing: boolean }>
  | Event<
      'chat-message-received',
      { senderId: string; message: string; isPrivate: boolean; timestamp?: string }
    >
  | Event<'chat-toggled', { isOpen: boolean }>
  | Event<'audio-muted-change', { muted: boolean }>
  | Event<'video-muted-change', { muted: boolean }>
  | Event<'ready-to-close', {}>;

export interface JitsiMeetType {
  launchJitsiMeetView: (options: JitsiMeetConferenceOptions) => Promise<void>;
  hangUp: () => void;
}
