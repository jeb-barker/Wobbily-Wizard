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
<br><img align="left" src="/screenshots/Home.png" width="200"> 
A cauldron section is where you will be able to create your potions with your ingredients. The ingredients will be in a subview, and you will be able to scroll and then drag your ingredients into the cauldron. Once they are there, you will be able to shake your phone to mix them together. Right now, you are able to drag a set array of ingredients into the cauldron, and when you shake your phone, it alerts you that your phone has been shaken.

<br clear="left"/>

### Shop
The shop screen will be the spot where the player can purchase various components for crafting their potions. 
<br><img align="left" src="/screenshots/Home.png" width="200"> 
Currently, the shop functions are not fully finished but the background is set up and correctly sized for UI to be put in, and the next step is to set up how the items will be shown, how you can buy them, and how to keep track of things like player balance, which items are sold when, and how often the shop will refresh.

<br clear="left"/>

### Friends
The friends screen showcases friends that you can add. After submitting the UUID of your friend in the textfield at the bottom of the screen, it adds a rectangle that displays their nickname and UUID. 
<br><img align="left" src="/screenshots/Home.png" width="200"> 
 There will be a button next to their name that will send them a potion that they can use in battle once a day. This will adjust the corresponding variables in firebase and allow them to use a friend potion.
 Here's some friend codes you can try:
 - 95F832FD-01CF-432F-852B-240E14ACB3D2
 - 9F111118-67C3-4B5A-B2DF-860E9ED6F814
 - D7879E34-BB4D-41F7-84AE-507A0217CB45
 - 0A153E4B-4558-469E-B049-CE5FA7A55782

<br clear="left"/>


## Technical Details
### Backend
On the backend, we’re using HealthKit paired with a CoreMotion Pedometer to track steps. (HealthKit is the only way to emulate steps for 3/4 group members). After opening the app, if you add some steps in the health app through the emulator, after about 60 seconds, the bar should update (if this doesn’t happen then you can press the ‘more button’). Theoretically, if you had an apple device, you would see live gyroscope-based step data going into the progress bar as well. The ‘more’ button automatically queries the HealthKit data and is mostly for debug purposes. As of now, HealthKit data is live up to the current minute (i.e. 5:27pm + 37s would only have data up to 5:27pm + 0 seconds). We're simply supplementing that data with the Pedometer to get live step counts.

### Notes
Since there's no way to get pedometer data in the emulator, the 'more' button on the Home page syncs the current number of steps with recently added steps in the Health App (using HealthKit).
Simply navigate to the Health App, manually add step data, and then press the 'more' button on the Home page to sync.
*note that this is only for debug purposes, and will likely be removed from production versions*
