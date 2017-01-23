# Things Export
Applescript for exporting items from Things app
Convert Things (from Cultured Code) database to Toodledo XML
https://culturedcode.com/things/

This script produces several XML to the user's desktop. Each file has up to 500 items so we are sure that we don't hit the upload limit of Toodledo.
It requires that Things.app is installed.


## Known Issues:
This script is really slow. Seems to cause Things to hit 100% CPU usage on a single core.
Guessing perhaps the Things Applescript implementation isn't parallelized at all or my first attempt at Applescript-ing needs some refinement!

There are also some ecoding problems with special characters, not sure why.

Also I haven't delineated Inbox, Today, Next, Scheduled, Someday etc. A grievous oversight I know but to be frank I only use Today and I couldn't come up with an elegant approach to pulling those categories out of Things without hard coding them into my script and iterating over each one in turn.
