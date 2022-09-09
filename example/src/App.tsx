import JitsiMeet from '@zenklub/react-native-jitsimeet';
import React from 'react';
import { StyleSheet, View, Pressable, Text } from 'react-native';

const conferenceOptions = {
  room: 'ReactNativeJitsiRoom',
  serverUrl: 'https://vc-dev.zenklub.com',
  userInfo: {
    displayName: 'React Native Jitsi Meet Example',
    email: 'example@test.com',
    avatar: 'https://picsum.photos/200',
  },
  featureFlags: {
    'add-people.enabled': false,
    'calendar.enabled': false,
    'call-integration.enabled': false,
    'close-captions.enabled': false,
    'chat.enabled': false,
    'invite.enabled': false,
    'ios.recording.enabled': false,
    'kick-out.enabled': false,
    'live-streaming.enabled': false,
    'meeting-name.enabled': false,
    'meeting-password.enabled': false,
    'pip.enabled': false,
    'raise-hand.enabled': false,
    'recording.enabled': false,
    'toolbox.alwaysVisible': false,
    'server-url-change.enabled': false,
    'tile-view.enabled': true,
    'video-share.enabled': false,
    'welcomepage.enabled': false,
    'fullscreen.enabled': false,
    'conference-timer.enabled': true,
    'prejoinpage.enabled': false,
  },
};

function App() {
  const startJitsiAsNativeController = async () => {
    /* 
      Mode 1 - Starts a new Jitsi Activity/UIViewController on top of RN Application (outside of JS).
      It doesn't require rendering JitsiMeetView Component.
    */

    await JitsiMeet.launchJitsiMeetView(conferenceOptions);

    /*
      Note:
        JitsiMeet.launchJitsiMeetView will return a promise, which is resolved once the conference is terminated and the JitsiMeetView is dismissed.
    */
  };

  return (
    <View style={styles.container}>
      <Pressable
        onPress={startJitsiAsNativeController}
        style={({ pressed }) => [
          styles.pressable,
          { opacity: pressed ? 0.5 : 1 },
        ]}
      >
        <Text style={styles.pressableText}>
          Start Jitsi on top of RN Application
        </Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pressable: {
    width: '80%',
    borderRadius: 15,
    height: 50,
    marginVertical: 10,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'blue',
  },
  pressableText: {
    fontSize: 17,
    fontWeight: 'bold',
    textAlign: 'center',
    color: '#fff',
  },
  jitsiMeetView: {
    flex: 1,
  },
});

export default App;
