# blackjackv1
Link to Github: https://github.com/Andyngo280/CMPE-137-Project

A BlackJack flutter project for CMPE 137

## Getting Started
To run the project on Android Studio without any out of bounds errors on the screen. Make sure the emulator screen size is at least 5.5 inches. But for the best user experience, 6 inches will be the perfect fit.
We recommend using the Pixel 5 emulator for the perfect screen.

1. Download the project.
2. To install the dependencies, run the following command in the terminal:
```
cd blackjackv1  
flutter pub get 
```
If there is an error to install the package please type the following in the terminal:
```
flutter pub add PackageName
example:
flutter pub add just_audio
flutter pub add flutter_switch
```
3. You may need to set up the configurations.
```
You can do this by clicking on "Add Configuration" on the top right.
Click on Add New and choose "Flutter"
Change the name to "main.dart"
In the Dart entrypoint, open the blackjackv1 >> lib >> main.dart. 
Press apply and press Ok.
```
4. Run the program.

If there is an error when trying to run the program, run the following command:
```
flutter run --no-sound-null-safety
```
