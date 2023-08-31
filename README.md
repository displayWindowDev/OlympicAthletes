# Olympic Athletes
As interest grows in the Olympics, people are getting more and more interested in knowing everything there is to know about the athletes that compete in each of the games.
As such, we would like to provide an application that allows the public to get to know them through mobile devices.


# Description
<p>
The Olympic Athletes project is a small sample application intended to illustrate skills on the different areas such as design, coding, good practices and patterns
It is coding test provided as a step through an application to a development department.

The project consists of a full mobile application on iOS that consumes the API and fulfil some requirements in the next section.
</p>

# Getting started
<p>
1. Make sure you have the Xcode version 14.0 or above installed on your computer.<br>
2. Download the project files from the repository.<br>
3. Open the project files in Xcode.<br>
4. Review the code.<br>
5. Run the active scheme.<br>
  
The application should start on the Simulator and you should see a list of Games with the athletes that competed into.<br>

If you have any issues or need help, refer to the documentation or contact the developers for assistance.<br>
You're now ready to know pretty much everything about the athletes that compete in each of the game.
</p>

# Usage
No particular information about how to use the project are required.<br>
Just explore the app and enjoy the contents.

Important: The servers may take too much time to respond, due to the large amount of data requested, and you may experiment a timeout error.<br>
In that case you can both <strong>retry</strong> through an alert that handles the error, or <strong>re-start</strong> the application after a while.

# Architecture
* Olympic Athletes project is implemented using the <strong>Model-View-Presenter (MVP)</strong> architecture pattern.
* Model has any necessary data or business logic needed to generate the data that has to be displayed.
* The View now consists of both Views and ViewControllers, with all UI setup and events. It is responsible for displaying the data to the user, such as, possibly, printing it to the console.
* The Presenter will be in charge of all the logic, including responding to user interactions, and updating Model and the UI (via delegate). The presenter will not be UIKit dependent. which means well isolated, hence easily testable.
* Project doesn't have an his own database.<br><br>

# Structure 
* "Controllers": The source code files of the ViewControllers and relative presenters of the project. Subviews used within a viewController are organized into subfolders.
* "Models": The source code files for modeling abstract entities.
* "Views": The source code files of custom views.
* "Network": Files or classes related to communicating with an external API. This could include code for making HTTP requests to a web server, parsing responses, and handling any errors that may occur.

# Running the tests
<p>The Olympic Athletes project can be tested using the built-in framework XCTest.<br>
To start testing the project, just reach the test files placed in the "test" folder, following the project structure.
Feel free to write any test functions using the XCTest.
</p>

# Deployment
Keep in mind that deploying an iOS app to the App Store requires having an Apple Developer account.

1. Click on the "Product" menu in Xcode and select "Archive." This will create an archive of your project.
2. Once the archive has been created, select it in the Organizer window and click on the "Validate" button to perform some preliminary tests on the app.
3. Once validation is complete, click on the "Distribute" button and select "Ad Hoc" or "App Store" distribution. 
This will create a signed IPA file that can be installed on iOS devices.
4. Follow the prompts in the distribution wizard to complete the distribution process.
5. Once the distribution is complete, you can use the IPA file to install the app on iOS devices

# Dependencies
This project does not use any dependencies.

# Workflow

* Reporting bugs:<br> 
If you come across any issues while using Olympic Athletes, please report them by creating a new issue on the GitHub repository.

* Reporting bugs form: <br> 
```
App version: 1.00
iOS version: 16.1
Description: When I tap on the Athlete nothing happens.
Steps to reproduce: Open the app, tap on any Athlete.
```

* Improving documentation: <br> 
If you notice any errors or areas of improvement in the documentation, feel free to submit a pull request with your changes.

* Providing feedback:<br> 
If you have any feedback or suggestions for the Olympic Athletes project, please let me know by creating a new issue or by sending an email to the project maintainer.

# Design 
* Design tool for our teams is [Figma](https://www.figma.com)
* All of the design is and must be only in one tool and currently it is Figma.<br>
* Colors in the Figma must have same name as colors in Xcode project.<br> 

# API 
* The project uses a REST API

