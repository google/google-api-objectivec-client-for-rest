#Google Sample Apps 
The apps in this folder are designed to provide examples of the basic workings of the Google Client Library.  They should not be used in production. 
Eg you should not ask for a Client key as it should be embedded within the codebase of your app. 

## Installation instructons
In order to use the example projects in this folder, you will need to ensure that you have downloaded the below two Git Submodules:
- gtm-oauth2
- gem-session-fetcher 


## How to download Git Submodules 
You can download Git Submodules using the following command: 
[Credit: Stackoverflow Question] (http://stackoverflow.com/questions/8090761/pull-using-git-including-submodule)


```
git clone git://url
cd repo
git submodule init
git submodule update
```

Then, add another step after the git pull.

```
git pull ...
git submodule update --recursive
```

##Requirements to use
These example apps need an oAuth Client key, which you can obtain from the [Google Developer Console](https://console.developers.google.com/).

###To obtain an oAuth client Key: 
1. Visit the [Google Developer Console](https://console.developers.google.com/
2. Click Credentials on the left hand navigation pane
3. Click the `Create Credentials Button` and select `oAuth Client id` from the resulting dropdown menu. 
4. Select the `IOS` radio button
5. Enter a memorable name for this key to help you identify it easily in the future. 
6. Copy the Bundle Identifier from your IOS App.  This is found in your main project target under the `General` tab
7. Click the `Create` Button and your are complete. 


## Note
These sample apps should automatically build and copy over the GTLR.framework as part of the build-and-run process.