# NetworkBrowser
Simple xcode iOS bonjour network browser written in Swift.

Don't expect too much, this is just a simple example of using a few types of views and accessing the network APIs.  I developed
it as a simple but functioning example.

## History

### 6 Oct 2018
Upgraded to Xcode 10.  The most significant change with Xcode 10 seems to be a real focus on Internationalization.  When I upgraded the code
I received a large number of warnings about missing constraints (views without any layout constraints may clip their content or overlap) that would 
cause a problem with internationalization.  The best guidance I 
found to resolve this problem was to watch WWDC 2018 [Creating Apps for Global Audiences](https://developer.apple.com/videos/play/wwdc2018/201/).
This video highlights the value of using embedded stacked views.  Sticking most of the controls inside stacked views and adding the constraints
as described in the video resolved the issues.  It was also good to see how to test an app early for right to left and for languages with longer words.
