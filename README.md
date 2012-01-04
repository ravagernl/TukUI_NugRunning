<img src="http://dl.dropbox.com/u/4618521/Wow/tukui_nugrunning.jpg" />
This is a skin for <a href="http://www.wowinterface.com/downloads/info10440-NugRunning.html">NugRunning</a>. NugRunning has the advantage over Tukui_ClassTimer of showing DOT timers on multiple targets as it gets the information from the combat log and not from the UNIT_AURA event.

A couple of options are inside, so you can modify the fonts.
Default options are tuned for Duffed UI.

<b>Modifying font, font size, and font flags</b>
When you are using a normal font(non pixel font) you might want to change the size and delete the monochrome property. There is a config section at the top of the lua. Look for the following:

<pre>local modifyfont = true
local fontflags = {C.media.uffont, 8, "MONOCHROME,OUTLINE"}</pre>
<b>Modifying position and size</b>
This AddOn only skins the bars. You still need to set the proper size and position with the slashcommands:

/nrun set width=214
/nrun set height=20
/nrun unlock
/nrun lock

More information on how to add your own spells to NugRunning or other options can be found on the NugRunning download page.

[ <a href="http://dl.dropbox.com/u/4618521/Wow/Tukui_NugRunning.zip">Download</a> ]