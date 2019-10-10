#!/bin/bash
# params:
#    targetdir the directory to put WP into
#    siteurl the url for the site this must be set up _before_ running this script
#    db the database name the site will use. wp-cli could use the data from config to set it up via the commands below, but currently manual input
#    dbuser the database user
#    ownerusername the actual owner's username
#    owneremail the email for the owner so they get an email that it's ready

# e.g.: ./tkinstall.sh --targetdir /var/www/html/tkinstall/test --db wptest --dbuser patrickmj --siteurl http://newdnsfromkarl.libary.northeastern.edu --ownerusername notme --owneremail notme@example.com

# latest user 1 pwd: %ULoAQXW$)R#)zj5nf don't worry, this is just on localhost. stuffing it here from the script's output for convenience

pluginversion=v1.2
themeversion=v1.2.2
wpversion=4.9.8

TKINSTALLDIR=$(cd `dirname $0` && pwd)

# adapted from https://www.golinuxcloud.com/how-to-pass-multiple-parameters-in-shell-script-in-linux/  
while [ ! -z "$1" ]; do
  case "$1" in
     --targetdir)
         shift
         targetdir=$1
         ;;
     --siteurl)
        shift
        siteurl=$1
         ;;
     --db)
         shift
         db=$1
         ;;
     --dbuser)
        shift
        dbuser=$1
         ;;
     --owneremail)
        shift
        owneremail=$1
         ;;
     --ownerusername)
        shift
        ownerusername=$1
         ;;
     *)
        echo 'something went wrong, and I should display help info someday' #eventually this will show help info
        ;;
  esac
shift
done

wp core download --path=$targetdir --version=$wpversion --skip-content

# see https://developer.wordpress.org/cli/commands/config/create/
wp config create --path=$targetdir --dbname=$db --dbuser=$dbuser --prompt=dbpass # the database password will be prompted for

wp db create --path=$targetdir

wp core install --url=$siteurl --admin_user=patrickmj --admin_email=p.murray-john@northeastern.edu --title= --path=$targetdir


# see note on https://developer.wordpress.org/cli/commands/core/install/ for the need to update
wp option update siteurl $siteurl --path=$targetdir

wp user create kyee kyee@northeastern.edu --role=administrator --send-email --path=$targetdir
wp user create arust a.rust@northeastern.edu --role=administrator --send-email --path=$targetdir
wp user create $ownerusername $owneremail --role=administrator --send-email --path=$targetdir


wp plugin install relevanssi --activate --path=$targetdir
wp plugin install siteorigin-panels --activate --path=$targetdir
wp plugin install black-studio-tinymce-widget --activate --path=$targetdir
wp plugin install widget-context --activate --path=$targetdir
wp plugin install better-wp-security --activate --path=$targetdir
​
wp theme install quest --path=$targetdir

cd $targetdir/wp-content/plugins
git clone https://github.com/NEU-Libraries/drs-toolkit-wp-plugin.git drs-tk

cd $targetdir/wp-content/plugins/drs-tk
git checkout $pluginversion

# tkpluginconfig.php includes API credentials, so is not in the repo.
# it should just be copied over into wherever this installer lives from a working copy
# and rename it tkpluginconfig.php

cp $TKINSTALLDIR/tkpluginconfig.php drs-tk/config.php
wp plugin activate drs-tk

cd $targetdir/wp-content/themes
git clone https://github.com/NEU-Libraries/drs-toolkit-wp-theme.git quest-child

cd $targetdir/wp-content/themes/quest-child
git checkout $themeversion

wp theme activate quest-child --path=$targetdir


