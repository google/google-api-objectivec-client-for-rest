#Google Sample App for Calendar

## Installation instructons
In order to use this project, you will need to ensure that you have downloaded the two Git Submodules 
- gtm-oauth2
- gem-session-fetcher 


##How to download Git Submodules 
You can download Git Submodules using the following command: 
[Credit: Stackoverflow Question] (http://stackoverflow.com/questions/8090761/pull-using-git-including-submodule)


```git clone git://url...
cd repo
git submodule init
git submodule update
```
Then afterwards, add another step after the git pull.

```
git pull ...
git submodule update --recursive
```
##Requirements to use
This app needs a Client key and Secret, which you can obtain from [here](https://console.developers.google.com/)

## Note
`This sample should automatically build and copy over the GTLR.framework as part of the build-and-run process.
```