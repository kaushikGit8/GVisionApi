# Version
1.0.0

# Synopsis : Cloud Vision Objective-C Seed Project

This app uses [Cloud Vision API](https://cloud.google.com/vision/) to provide text, entity and face detection on image captured from camera or image selected from gallery.
The aimed use case is to develop an app for blind and visually impaired users to visualize the objects or obstacles around them. The app uses text to speech in combination with the Google Cloud vision api to provide hassle free user experience.  

## Prerequisites
- An API key for the Cloud Vision API
- An OSX machine or emulator
- [Xcode 8][xcode]

## Running the app

- As with all Google Cloud APIs, every call to the Vision API must be associated
  with a project within the [Google Cloud Console][cloud-console] that has the
  Vision API enabled. This is described in more detail in the [getting started
  doc][getting-started], but in brief:
  - Create a project (or use an existing one) in the [Cloud
    Console][cloud-console]
  - [Enable billing][billing] and the [Vision API][enable-vision].
  - Create an [API key][api-key], and save this for later.

# Future enhancements
- Add Alchemy API to build context of the text detected
- Auto-tagging of the images captures for easy search
- Sirikit integration to search images of particular "tags" and share with Others

# Relevant Hyperlinks
- [QHSpeechSynthesizerQueue][QHSpeechSynthesizerQueue]
- [TGCameraViewController][TGCameraViewController]

[vision-zip]: https://github.com/GoogleCloudPlatform/cloud-vision/archive/master.zip
[getting-started]: https://cloud.google.com/vision/docs/getting-started
[cloud-console]: https://console.cloud.google.com
[xcode]: https://developer.apple.com/xcode/
[billing]: https://console.cloud.google.com/billing?project=_
[enable-vision]: https://console.cloud.google.com/apis/api/vision.googleapis.com/overview?project=_
[api-key]: https://console.cloud.google.com/apis/credentials?project=_
[QHSpeechSynthesizerQueue] : https://github.com/quentinhayot/QHSpeechSynthesizerQueue
[TGCameraViewController] : https://github.com/tdginternet/TGCameraViewController
