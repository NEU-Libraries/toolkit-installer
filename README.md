# toolkit-installer
simple script and related files to automate spinning up a CERES WP site

# Usage

Park this repository someplace that is not web-accessible. Copy a filled-in `config.php` file for drs-tk into that directory, and rename it `tkpluginconfig.php`.

Run the script with the following options:

* targetdir the directory to put WP into
* siteurl the url for the site this must be set up _before_ running this script
* db the database name the site will use. wp-cli could use the data from config to set it up via the commands below, but currently manual input
* dbuser the database user
* ownerusername the actual owner's username
* owneremail the email for the owner so they get an email that it's ready

for example:

```
./tkinstall.sh --targetdir /var/www/html/tkinstall/test --db wptest --dbuser patrickmj --siteurl http://localhost/tkinstall/test --ownerusername notme --owneremail notme@example.com
```

The db user must exist, and you will be prompted for the password. After that, everything is automated.

The siteurl might have to be changed later if the domain has not already been set up.

The user 1 Admin's password will appear in the output from the script, so scroll up in the output to find it if needed.



