# Find Me

An image based solution for indoor localization

## Getting Started

Make sure you have the latest version of Flutter installed

```flutter --version```

Clone the repo

```git clone https://github.com/9dubs/Find-Me.git```

Due to time constraint, we had made use of 2 third party APIs for both image localization as well as indoor mapping. We plan to replace both of them with custom APIs and workarounds in the coming few months as and when the work progresses.

But for the time being, go ahead and sign up for each of these sevices to get your unique ```API key``` :

- [Easy AR](https://www.easyar.com/view/signUp.html) for image recogntion(via flutter package)  
- [Situm SDK](https://dashboard.situm.com/) for indoor mapping

## Image Localization

This API is being used via a third party plugin called [AR Quido](https://pub.dev/packages/ar_quido). Once signed up on the Easy AR website, go ahead to the profile dashboard to get your ```Sense Authorization``` key. Make sure to copy your ```Sense Authorization``` Key and paste it in your application's ```AndroidManifest.xml``` file, right in the application metadata, or simply follow the instructions at [pub.dev](https://pub.dev/packages/ar_quido). Include your reference images with ```.jpg``` extension and verify they reside in ```assets/reference images```. Once thats done, populate the ```referenceImageNames``` list in ```lib/main.dart``` with the reference image filenames.

```
<meta-data
           android:name="com.miquido.ar_quido.API_KEY"
           android:value="<YOUR_SENSE_LICENSE_KEY>" />
```

## Indoor Mapping

Add [Situm Plugin](https://pub.dev/packages/situm_flutter) for flutter. Locate your institution within the map builder and upload respective floorplans in PNG in order to register your bulding. Make sure to adjust the map perfectly. once thats done, populate the map by inserting ```Points of Interests``` or POIs and paths connecting those POIs for navigation purposes. Once bulding is registered, head over to your [dashboard](https://dashboard.situm.com/) and copy the ```bulding ID```, and mention it along with unique ```API``` key as explained in their plugin page. I would suggest you follow the official Flutter [documentation](https://situm.com/docs/a-basic-flutter-app/) if you are building from scratch or need any further reference in the same.

## Building the app and testing

Once everything is setup, perform ```flutter run``` to run the app in debug mode, and look for errors in the logcat/debug console.
