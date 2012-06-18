SNSClientSample-ios
=======================

Sample SNS Client for iOS using 
- iOS Accounts and Twitter frameworks
- Facebook iOS SDK

Demonstrates how to implement the following features:
- Twitter
  - Accessing registered Twitter accounts on the device
  - View the profile image of the selected account
  - Update profile image for the selected account
  - View timeline of the selected account ( currently loading only recent 20 tweets )
  - Simple/Naive Image Quote generator for Tweet
- Facebook
  - Login/Logout (Single Sign On)
  - Simple Wall Post Publishing with hard-coded message
  - Facebook Photo upload: Reused Simple/Naive Image Quote generator (mentioned above)

Contribution is always welcome

Short-term improvement plan
- Import contacts from Twitter and/or Facebook
- Each contact will have the following attributes (for preferrence management), A.K.A Aquarium Management of the iTunes Video Podcast: "iOS App Developtment for Korean Beginners"
  - score ( how much the user like this contact)
  - any personal information the user want to keep such as mobile number, age, and so on
- Facebook
  - Posting to a page/group
- Aggregated News Feed
  - Twitter Timeline
  - Facebook News Feed
  - Filter: based on score of the imported contacts. For example, Tweets or Posts from the prefered person will be displayed at higher priority
