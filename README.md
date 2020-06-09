# Overview
Password Manager is an iOS mobile application that manages passwords to other app accounts on a mobile device. As this is an iOS app, our code was developed using Xcode Storyboard and Swift. Our code can be found in the `PasswordManager` directory here (https://github.com/ECS153/final-project-j2ve/tree/master/PasswordManager/PasswordManager).

There are two main goals for this project. The first goal is to make an appealing, user-friendly, and simple-to-use application that allows users to manage their passwords. The second goal is to make an application that gets users to use non-generic, unique, and complex passwords for their user accounts.

Our updated slides about our project are available here (https://docs.google.com/presentation/d/1dz6lgRXgo42o4hfDJ9VSRGMHvWzh3uVO7UAl8OTvy0s/edit?usp=sharing).

# Design
As the main issue we are addressing here is password security, we implemented different layers within our app to verify a user’s digital identity. These layers are represented by different screens in our app, which we detail more in-depthly in the following sections.

## Screen: Login Screen
This is the first screen that pops up upon loading the app. This is where a user can enter in their email and password associated with this Password Manager app in order to gain access into this app in the first place. The entered email and password are checked via the Firebase Authentication service, which we have connected to this application for email and password verification.

If they login successfully, then they are subsequently redirected to the Security Questions screen. If they are a brand new user to this Password Manager app, then they can select the button at the bottom of the screen to redirect themselves to the Create New Account screen instead.

This screen’s code can be seen here (https://github.com/ECS153/final-project-j2ve/tree/master/PasswordManager/PasswordManager/LoginViewController).

## Screen: Create New Account
On this screen, a new user will be able to create a user account for the Password Manager app. On the top half of the screen, the user will be able to first enter in their email address and the master password they want to use to enter this app with. The first text field on this section of the screen is set up to check that the entered email address is a valid email address. Similarly, the text field for the master password is set up to ensure that the password that the user creates is at least 6 characters long.

On the bottom half of the screen, the user is instructed to create at least 3 Security Questions and respective answers of their own choosing for this new account. By default, there is only one question and answer text field pair in this section of the screen. The user will have to select the “Add a question” button to create at least 2 more security questions. A scroll view is set up to accommodate the new screen size each time a new question text field is generated. Each generated text field is also set up to check that they have actually been filled in.

Once all text fields are verified to have been filled in properly, a Firebase Authentication API method is called on the email and password to create a new user for our app, which is stored on a newly made document that is named after the auto-generated user id from Firestore. The verified email, password, and security questions are stored in that document. In addition, a collection of AppAccountModel is written into this document to keep track of other app accounts that the user registers to their Password Manager account.

The code for this screen can be found here (https://github.com/ECS153/final-project-j2ve/tree/master/PasswordManager/PasswordManager/CreateNewAccountViewController).

## Screen: Security Questions
Every time a user logs into our Password Manager app, they will need to verify their digital identity by answering 3 randomly selected Security Questions that are associated with the account they are trying to log into. There is a function that randomly selects 3 security questions from the associated (master) account document in Firestore. These questions are pulled from the Firebase database document that is associated with this account. The answers that the user inputs must match the ones in the database before they can proceed to the Registered Accounts screen.

The code is available here (https://github.com/ECS153/final-project-j2ve/tree/master/PasswordManager/PasswordManager/SecurityQuestionsViewController).

## Screen: Registered Accounts
This screen displays a list of all of the other app accounts that have been registered and associated with this user's master account. Each of these accounts can be tapped on for an automatic sign-in to the selected account. The user can also tap on the plus icon on this screen to add a new account for this Password Manager to keep track of. Tapping on this icon redirects the user to an Add Account screen.

This code can be seen here (https://github.com/ECS153/final-project-j2ve/tree/master/PasswordManager/PasswordManager/RegisteredAccountsViewController).

## Screen: Add Account
On this screen, a user can enter in the account email or username, password, and app name of the new account that they want the Password Manager to manage. Each time the user adds an account, the information they input into these text fields is written to a new document that gets stored within a Firebase collection called registered accounts.

# Experiments and Results
To test our app, we created a master app account, then several dummy accounts on our app by storing username and password information about other mobile app accounts. Next we made sure that we could log into each of these dummy accounts before adding them into the Password Manager app to manage (using the previously mentioned master account). We would then log out of these accounts and log back in to ensure that each of these dummy accounts were stored and retrieved correctly from the registered accounts collection in the master account.

In order to test and explore deep linking in our app, we first needed to create a demo app with a proper username and password login flow.  In addition to this, given that not all mobile apps store information on a database and the simplicity of our demo app (it only had 3 screens), we decided to look into using keychain to locally store the information.  Considering all this, the main reason why we decided to make a second app was to test and enable deep linking since in order to connect to and open another app on one’s device, said app needs to give our password manager the permissions to access its information.  That is the main reason why our deep linking code refers to the demo app's query information instead of a generic query. Our app is capable of generating a generic query with another app name, but it would need permissions. So we use our demo app as a secondary app to illustrate and test deep linking. Another thing to note was that if we had enough time, we wanted to look more into keychain, so in the case that our password manager app does not have access to the database, we could then pull the locally stored information for it.  

Afterwards, we asked a few family members to test our Password Manager app to see how they felt about it, since as the developers of this project, we are prone to bias. The general consensus was that having only to memorize a master password to access this app and its services was one of the most appealing features of this app, and that there were just enough layers for the users to be comfortable with securing their passwords, while staying mindful of consumer comforts and needs.

We had also hoped that this app would make users aware of the importance of having unique and complex passwords in keeping their accounts secure, but those we had asked to test this app all stated that they were already aware of this. Nonetheless, we are glad that they are aware that they do not necessarily need to sacrifice easier accessibility to accounts for security.

