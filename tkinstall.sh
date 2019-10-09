#!/bin/bash
# params:
#    targetdir the directory to put WP into
#    sitetitle the title for the site
#    siteurl the url for the site
#    db the database name the site will use. wp-cli will use the data from config to set it up via the commands below
#    dbuser the database user
# e.g.: ./tkinstall.sh --targetdir /var/www/html/tkinstall/test --db wptest --dbuser patrickmj --sitetitle "Site Title" --siteurl http://newdnsfromkarl.libary.northeastern.edu


TKINSTALLDIR=$(cd `dirname $0` && pwd)

# adapted from https://www.golinuxcloud.com/how-to-pass-multiple-parameters-in-shell-script-in-linux/  
while [ ! -z "$1" ]; do
  case "$1" in
     --targetdir)
         shift
         targetdir=$1
         ;;
     --sitetitle)
         shift
         sitetitle=$1
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
     *)
        echo 'no' #eventually this will show help info
        ;;
  esac
shift
done

wp core download --path=$targetdir --version=4.9.8 --skip-content

# see https://developer.wordpress.org/cli/commands/config/create/
wp config create --path=$targetdir --dbname=$db --dbuser=$dbuser --prompt=dbpass # the database password will be prompted for

wp db create --path=$targetdir #TODO: might be redundant, install might do it

wp core install --url=$siteurl --title=$sitetitle --admin_user=patrickmj --admin_email=p.murray-john@northeastern.edu --path=$targetdir
​
# see note on https://developer.wordpress.org/cli/commands/core/install/ for the need to update
wp option update siteurl $siteurl --path=$targetdir

wp user create kyee kyee@northeastern.edu --role=administrator --send-email --path=$targetdir
wp user create arust a.rust@northeastern.edu --role=administrator --send-email --path=$targetdir

wp plugin install relevanssi --activate --path=$targetdir
wp plugin install siteorigin-panels --activate --path=$targetdir
wp plugin install black-studio-tinymce-widget --activate --path=$targetdir
wp plugin install widget-context --activate --path=$targetdir
wp plugin install better-wp-security --activate --path=$targetdir
​
wp theme install quest --path=$targetdir

cd $targetdir/wp-content/plugins
git clone https://github.com/NEU-Libraries/drs-toolkit-wp-plugin.git drs-tk

# tkpluginconfig.php includes API credentials, so is not in the repo.
# it should just be copied over into wherever this installer lives from a working copy

cp $TKINSTALLDIR/tkpluginconfig.php drs-tk/config.php
wp plugin activate drs-tk

cd $targetdir/wp-content/themes
git clone https://github.com/NEU-Libraries/drs-toolkit-wp-theme.git quest-child
wp theme activate quest-child --path=$targetdir


