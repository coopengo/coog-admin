# Oauth Setup

If you want to set up a b2c portal, you will have to follow this guide
to setup the workflow.

## Edit configuration

First you need to indicate where coog-api and front-end application are.

``` bash
./conf edit
```

``` bash
COOG_API_URL=<server location>
COOG_API_APP_URL=<front-end location> if different from <server location>/web/
```

## Create API'S account

Then you will have to create some API's provider account like :

-   google - OK
-   facebook - In progress
-   twitter - NOK
-   ... and so on

Those are used to delegate user connection.

### Google account

First of all you have to go [there](https://console.developers.google.com)

If you don't have any project yet, then google will ask you to create one.

Name it, choose your organization, your zone and wait until he it is created.

Click on the notification about your created project.

You will be redirected into your dashboard project.

Take a look into first step section.

You will see a subsection "Activate API ...", click it, you will be redirected.

You see some available APIs but maybe not the one we need "GOOGLE+ API",
so click on browse all and just type "GOOGLE+ API" in the search bar.

Click on activate API

Then a new API dashboard appears and ask you to create identifiers to start. So click it.

#### First step

Which API do you use ?
GOOGLE+ API

Which plateform do you use to call API ?
Web server (example: Node.js or Tomcat)

Which data would you acces ?
Data user

Then click on the button

#### Second step

Name your client id

JS Origin authorized :

Enter your server address : <http://path:port>

Redirect URL authorized :

Enter redirect address url like this : <http://path:port><API_PATH>/grant/connect/google/callback

Click ont he button

#### Third step

Select your mail address and set the name that will be displayed for your user.

(optional) You can customize other things like CCG, Logo, HomePage and Privacy rules.

#### Forth step

Download the file, open it and open coog configuration

``` bash
./conf edit
```

Then just type those two variables

```
COOG_API_GOOGLE_SECRET=<client_secret>
COOG_API_GOOGLE_KEY=<client_id>
```

After that you just need to run the container or restart it.

``` bash
./web server

./upgrade
```

Now your application can delegate authorization.
