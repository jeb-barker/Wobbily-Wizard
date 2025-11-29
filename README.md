# Wobbily Wizard
##### A game for iOS devices that promotes physical wellbeing and social connection through a whimsical app.

## Overview
The main goal of the game is to brew potions, walk to an evil wizard, and defeat them in mystical wizard combat!
> Walking in the real world gets the user closer to the wizard, and gives them gems
> Gems can be used to purchase ingredients in the shop
> Ingredients can be brewed into potions at the cauldron
> After meeting the step goal, the user can choose to fight the evil wizard, using the potions they brewed to defeat him.

## Details
### Landing Screen
The first time a user opens the app, they are prompted to input a nickname. This then creates a new user in the firebase database!

### Home
The Home screen is the main tab of the app.
<br><img align="left" src="/screenshots/Home.png" width="200"> 
- Every step gives the user one gem
- A progress bar at the top shows the user's progress towards the current step goal
- When the user reaches the step goal, a button appears allowing them to enter the Fight Screen
  
<br clear="left"/>

### Cauldron
The Cauldron screen is where the user goes to use the ingredients that they've purchased to brew potions.
<br><img align="left" src="/screenshots/Cauldron.png" width="200"> 
Brewing potions is done by dragging ingredients into the cauldron, and shaking you phone a certain amount of times. When you open this page, you are met with the ingredients that you have in your inventory displayed at the top of your screen. If you do not have a certain item, it will not appear as an available ingredient. If you have more than one ingredient, then only one will appear, since for each recipe you only need one of a certain item. From those displayed items, you drag them one by one into the cauldron. The ones in the cauldron will apear in an array displayed below the cauldron. If you try and drag a duplicate of an item, it will alert you and tell you that this action is not allowed. If at any point you want to empty your cauldron, you can click the "reset" button, which will clear the cauldron and put the items back into the player's inventory. In order to click the "brew" button, you must have one of these recipes in the cauldron:<br>
- 🌻(sunflower), 🌶️(hot pepper), 🌡️(thermometer), 🧨(fire cracker) = fire potion
- 🔌(cable), 🔋(battery), ⚡(lightning), 📱(device) - electric potion
- 🐍(snake), 🧪(vile), 💀(skull), ☢️(nuclear waste) - poison potion
- 🧊(ice cube), 🍨(ice cream), 🥶(frozen fred), 🐧(penguin) - ice potion<br>
Once you do, you can click "brew" and a different cauldron image will appear. There will be a now bubbling cauldron, and a shake counter below it. You must shake the phone 10 times to brew the potion of your choosing. With every shake, the bubbles will change. Once you have shaken the phone the right amount, there will be an alert that you now have a brewed potion, that potion goes to your potion inventory to be used in the fight screen, and you can now start again with brewing your next potion. All of this is directly connected to the environment object PlayerData, which allows for direct inventory deleting and adding when you put things in and out of the cauldron.

<br clear="left"/>

### Shop
The shop screen will be the spot where the player can purchase various components for crafting their potions. 
<br><img align="left" src="/screenshots/Shop.png" width="200"><br>
To use the shop screen, the user must tap of the icon of the item that they would like to purchase. Each item has the cost in gems that it is worth on the right side of the book, and in order for the users purchase to go through the program checks that they have enough gems to buy it, which is displayed in the top left corner of the screen. Once the item is bought, the item is put into the users inventory. The items in the inventory change every 36 seconds currently (36 is just a test amount, gotten from 3600 seconds which is an hour), and it is set to not have more than one of the same item displayed at the same time.

<br clear="left"/>

### Friends
The friends screen showcases friends that you can add. After submitting the UUID of your friend in the textfield at the bottom of the screen, it adds a rectangle that displays their nickname and UUID. 
<br><img align="left" src="/screenshots/Friends.png" width="200"> 
 Additionally, you can send potions to friends with the plane icon. When you press it, information is put into the firebase database, and allows the friend to claim the potion they were sent. Upon claiming the potion, their relationship increases, which increases the power of the potion if you continously send them to the same person. 
 <br> <br>
 Here's some friend codes you can try:
 - 708CC979-3F12-4A86-B9B3-7DD543E02AC6
 - CCB5E982-AB12-498E-BA3A-1664827DEE3A
 - F25EFC19-6EA7-426F-85DE-44B9EB63ED0E
 - 3184D3AD-3B51-4CD8-A2F3-3CCAEF3B6B85

<br clear="left"/>

### Fight
The Fight screen is where you battle with the evil wizard. You have 10 turns to attack the evil wizard, using a potion each turn.
<br><img align="left" src="/screenshots/Fight.png" width="200"> 
- Each turn, the evil wizard is weak to a different type of potion, and using the correct one will deal double damage.
- Each turn the player can either pass or choose a potion (if one is available)
- Upon choosing a potion, the evil wizard's crystal ball will show a series of numbers.
  - The player should draw a line on their summoning circle (the black area) in the order of numbers that shows in the crystal ball
  - If the player draws correctly, they will do full damage
  - If the player draws incorrectly, they will do half damage
  - The player has five seconds to draw the shape
- After the fight, the player can press the back button to go back to the Home screen
- If the player wins, the step goal will increase by 20%, otherwise it will stay the same. Either way, the player will have to walk at least 300 more steps if they want to fight the evil wizard again.
- The player can press the friend potion button (next to the pass button) if they have claimed one from one of their friends
  - The friend potion gives an extra 20% damage on the attack made after its use.

<br clear="left"/>


## Technical Details
### Backend
On the backend, we’re using HealthKit paired with a CoreMotion Pedometer to track steps. (HealthKit is the only way to emulate steps for 3/4 group members). After opening the app, if you add some steps in the health app through the emulator, after about 60 seconds, the bar should update (if this doesn’t happen then you can press the ‘more button’). Theoretically, if you had an apple device, you would see live gyroscope-based step data going into the progress bar as well. The ‘more’ button automatically queries the HealthKit data and is mostly for debug purposes. As of now, HealthKit data is live up to the current minute (i.e. 5:27pm + 37s would only have data up to 5:27pm + 0 seconds). We're simply supplementing that data with the Pedometer to get live step counts.

### Notes
Since there's no way to get pedometer data in the emulator, the 'more' button on the Home page syncs the current number of steps with recently added steps in the Health App (using HealthKit).
Simply navigate to the Health App, manually add step data, and then press the 'more' button on the Home page to sync.
*note that this is only for debug purposes, and will likely be removed from production versions*
