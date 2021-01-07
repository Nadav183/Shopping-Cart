# Shopping List - App Description

An app to help manage a personal shopping list. 
The app lets you make a list of items you wish to have in your house, along with their quantities and prices.

The app then displays two screens:
1. A stock screen - where you can keep track of the items you currently have
2. A shopping list - An interactive list of items you are missing (based on the stock screen).

So instead of rewriting a list on paper for every trip to the grocery shop (and let's face it, forget half and overbuy the other half),
you just open the app when you are already at the shop and simply see all the items you like to buy and how much of them you need.

## Technologies Used

Flutter\Dart - The app itself is written in the Dart language over the Flutter framework. Utilizing the framework's Widget-based Object Oriented programming and it's asynchronous state-management capabilities.

BloC - The app's state-management is done with the BloC package which is based on the RX architecture in addition to Flutter's state management, Bloc helped managing stateful objects that are managed by several Widgets in the app. For example, the list of groceries can be altered by adding, deleting or editing items, each of these can happen in various ways, which ultimately required the list's state to be separated from any specific stateful widget.

SQLITE - The data persistence in the app is done with a SQLITE-based DB kept locally on the phone. This is acheived with the "sqflite" Flutter package which allows running SQLITE commands in flutter and manage the DB using flutter. Some SQLITE commands were done with sqflite shortcut functions but most were done with raw SQLITE code.

Material Design - Flutter's design is based on Material Design assets and style.

## Features

Inventory Page:
 - Display your items in collapsable categories
 - Manage and follow the quantity you have of each item
 - Edit existing items
Shopping Cart Page:
 - Display a shopping list based on your inventory
 - Swipe items to remove them from list once found
 - Have an assessment of the total price of the cart
