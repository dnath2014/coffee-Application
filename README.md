# coffee-Application
This application displays list of coffee and the details of each coffee can be obtained by clicking on individual coffee. Details of each coffee can be shared.

iOS version supported: iOS 7.1+ and iOS 8+
Device supported: iPhone

Third Party Library used: Mantle, Reactive Cocoa, AF Networking.

Offline usable: This app can be used offline. This project uses NSKeyedUnarchiver and NSUserDefaults to store the information related to coffee so that they can be used when the device is offline. 

Handling orientation change: The layout for the detail view is changed to handle orientation change.

Building the project:
Open coffeeApp.xcworkspace and build and Run



Class Description:

coffeeManager - Used to generate the singleton object

coffeeClient - Used to make Networking calls

coffeeItem - Individual coffee item in the array after parsing jason response

coffeeDetail - Details of coffee after parsing jason response

coffeeTableViewController - Displays the list of coffee in a tableview

coffeeDetailViewController - Displays details of coffee

coffeeTableViewCell - tableview cell without image

coffeeImageTableViewCell - tableview cell with image

