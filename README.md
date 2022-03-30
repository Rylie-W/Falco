# FALCO

This is the source code of our **Falco** project in 2022 Google Solution Challenge.

Falco is an application using gaming mechanism to help users build good consumption habits and reduce food waste. It’s built with **Flutter** which combines fun and convenience and presents animations with **Rive**.

We also offer shopping receipts scanning function, which is realized by integrating Google Cloud Vision API with the backend service deployed on Google Cloud Platform. The backend code can be found at [Falco-Server](https://github.com/Rylie-W/falco-server).

## Getting Started

We only developed Android version for now. You can directly download the APK at the root directory, also see the link [here](https://github.com/Rylie-W/Falco/releases/download/apk/base.apk).

You can also run this app locally by the following steps:

+ ### Requirements(versions only for suggestion)

  + Flutter (Channel stable, 2.8.1, on Microsoft Windows [Version 10.0.19044.1586])
  + Android toolchain - develop for Android devices (Android SDK version 32.1.0-rc1)
  + Android Studio (version 2021.1)
  + Connected Android Device/ Emulator in Android Studio 

+ ### Download project:

  ```shell
  git clone https://github.com/Rylie-W/Falco.git  
  cd less_waste
  ```

+ ### To compile the APK:

  ```shell
  flutter run --no-sound-null-safety
  ```

+ ### You will see the APK is compiled and installed on your Emulator or Android device.