# seashell-digging
FiveM Custom QBCORE seashell digging script, for learning purposes.
Based on jim-mining (https://github.com/jimathy/jim-mining) by jimathy. Many thanks!

- Customisable via config.lua
  - Locations (seashells, peds)
  - Peds (to buy from/sell to)
  - Items
  - Rewards/prices
  - Blips
  - Language (en/pt)
  
## Custom Items & Images
  ![General](https://i.imgur.com/kjJ1sUB.png)

## Dependencies
- qb-menu - for the menus
- qb-target - for the third eye selection

# How to install
- Place in your resources folder
- Add the following code to your server.cfg/resources.cfg
```
ensure seashell-digging
```
- Add the images to your inventory folder (qbcore\resources\[qb]\qb-inventory\html\images)
- Put these lines in your shared.lua (qbcore\resources\[qb]\qb-core\shared\items.lua)

```
	-- seashell-digging
	["beach_shovel"] 				 = {["name"] = "beach_shovel", 			  		["label"] = "Beach Shovel", 			["weight"] = 2000, 		["type"] = "item", 		["image"] = "beach_shovel.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "A beach shovel. Can be used to dig things in the sand."},

	["seashell_1"] 				 	 = {["name"] = "seashell_1", 			  		["label"] = "Seashell Type A", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "seashell_1.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "A cute little seashell that can be sold to someone interested!"},
	["seashell_2"] 			 		 = {["name"] = "seashell_2", 			  		["label"] = "Seashell Type B", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "seashell_2.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "A cute little seashell that can be sold to someone interested!"},
	["seashell_3"] 				 	 = {["name"] = "seashell_3", 			  		["label"] = "Seashell Type C", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "seashell_3.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "A cute little seashell that can be sold to someone interested!"},
	["seashell_4"] 			 		 = {["name"] = "seashell_4", 			  		["label"] = "Seashell Type D", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "seashell_4.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "A cute little seashell that can be sold to someone interested!"},
	["seashell_5"] 			 		 = {["name"] = "seashell_5", 			  		["label"] = "Seashell Type E", 			["weight"] = 500, 		["type"] = "item", 		["image"] = "seashell_5.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["combinable"] = nil,   ["description"] = "A cute little seashell that can be sold to someone interested!"},
```
