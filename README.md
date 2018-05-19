# ColorLoversList

Created by Grzegorz Biegaj

## Project description

ColorLoversList is just an iOS demo app presenting clean code and application architecture.
The main feature of the app is to show patterns, palettes and colours comming from color lovers community.  

### How it works:
- App shows lovers (users) list soted by high rating
- User can select one of the lover
- Depending on the selected tab (patterns, palettes, or colours) picture list will be shown
- By selecting particular picture user can see it on the full screen

NOTE:
- Application uses colour lovers API: http://www.colourlovers.com/api

## Architecture

### Modified MVC
Because of usage storyboards introduction of pure MVVM is not so easy, because view is integrated with ViewControllers. Instead of it View Controller is separated by ViewModel and Controller

### Storyboards
For that simple app storyboards are good solution. Storyboards are split to possible small scenes accordingly to the ViewControllers

### Unit tests
Most of the possible unit tests exists

### Dependency injection
Because of usage unit tests it was necessary to introduce dependecy injection to separate components.

### Dependencies
No any dependencies and dependeny manager

### Programming tools
Xcode 9.3, swift 4.1
