## Adding plots to the GUI

The DDU Data GUI stores plotting functions in a package called `plots`. When creating a plot function to add to this package pay attention to the following:

1. No figure handle is created or referenced. The GUI will use its own figure handle and axis sub-handle that throws a fit if you try to introduce an additional reference. Trying to pass that reference to a function creates a black hole that swallows the universe. You're better off without it, trust me.

2. Write a comment documenting the purpose of the function underneath the function header. This step goes miles when examining large packages with the `help` command. 

3. At the present time, all plot functions are hardcoded into the GUI script. In order to add a function to the GUI it needs to be referenced by the drop down list and the push button. If you don't know how to do this, just push your function to the functions package and open an issue with the issue tracker, then attach someone who does to your ticket. Or just yell incoherently at the script author until it's added. I'd really prefer you didn't, but I know it's inevitable. 
