Application

Create an application with a custom “browser”.



Required functionality

Filtering web browser application.
Minimum functionality:
input field for web link;
back button;
forward button;
add a filter button. On the button tap open a dialog with a field to input the filter string. When the user adds a filter, disallow to open links containing rows from the filter;
button to open filters table view with the ability to remove.
Min iOS 12.


Stack

Swift
UIKit
Code-only layout
Auto Layout
WebKit
MVC
Third-party libraries
Cocoapods


Additions & explanations

Create UI using code. Only the LaunchScreen.storyboard should remain in the project. Pure NSLayoutConstraints or third-party library (SnapKit for example)

Hint*. The user enters a google.com link, opens it and enters something into the search. Adds a filter such as "badsoft". If a user clicks on a link in the search that contains a word from the filter, do not open it, but show the dialog that this page is blocked.

Extra*. Add rules for the filter. For example, at least 2 characters and no spaces.
