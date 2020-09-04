# Usage

Enter the sh_plugin.lua file and edit the PLUGIN config options to your liking.
All of the options are explained in here.

When it comes to adding your factions and classes to certain channels on spawn, keep in mind that if you want them to have more than one channel, all you need to do is add another `table.insert(client.CommsAccess, "shortName")`. Short name is one of the values you input to the table of your channels values.

# Chat Commands

### `/setradiochannels <string> ...`
*Example: /setradiochannels unsc innie*

*Example: /setradiochannels unsc*

##### Access

Admin only (Easily changeable to another usergroup if you know what you're doing)

##### Usage

Look at a channel replenisher entity and set in the string of the channels that you would like that entity to give when used by a player.

In the example, you can use a series of strings or just one. To add more than one channel, add a space between the channels you want to give.

### `/stripcomms`

##### Access
All with the exception being that you disabled stripping comms

##### Usage
Be close to a player and use command to strip comms off a player. Player must be cuffed if the config setting is set to players must be cuffed to be comms stripped.

### `/dropcomms <string> ...`
*Example: /dropcomms unsc innie*

*Example: /dropcomms unsc*

##### Access
All

##### Usage
Use command to drop comms into a radio box that others can pick up. String used for the comms is the shortText, so this will be the prefix (text in square brackets before message) of the comms that shows in chat.

### `/togglecomms <string> ...`
*Example: /togglecomms unsc*

##### Access
All

##### Usage
Use command to toggle usage of comms and the comms showing up in your chat window without dropping the comms all together. String used for the comms is the shortText, so this will be the prefix (text in square brackets before message) of the comms that shows in chat.

# Console Commands
### `textcomms_savereplens`
Saves all current Comms Replens on the map with all the active comms set on them via `/setradiochannels`

### `textcomms_loadreplens`
Removes all current Comms Replens on the map and will load up any of the saved ones via the previous command. All comms channels set and saved will be loaded.

###### *Note: If you prefer to use PermaProps, the Comms Replens are compatiable with PermaProps should you prefer to use that method over these console commands*

# Videos

https://www.youtube.com/watch?v=HeNzGxhODEY

https://www.youtube.com/watch?v=cnAsykyUlp0
