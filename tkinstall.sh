#!/bin/bash
​
#  Drop this script into the directory to be modified. Edit and run script.
#  Delete the working copy of the script when done.
​
​
#  Define the variable here before running script.
here="/mnt/wordpressdata/folder_I_want_to_change"
​
#  saves the absolute path of the current working directory to the variable cwd.
cwd=$(pwd)
​
​
​
cd $here/
echo "We are currently in this directory: $cwd"
if [ $cwd = $here ]
then
​
   cd $here/wp-content/themes
   wp theme install quest
​
   cd $here/wp-content/plugins
   git clone https://github.com/NEU-Libraries/drs-toolkit-wp-plugin.git drs-tk
​
   cd $here/wp-content/themes
   git clone https://github.com/NEU-Libraries/drs-toolkit-wp-theme.git quest-child
​
   cd $here/wp-content/themes/quest-child
   mkdir overrides
   touch overrides/style.css
   echo "<?php //silence is golden" > overrides/functions.php
​
   cd $here/wp-content/themes
   rm -rf twentyfifteen 
   rm -rf twentysixteen
   rm -rf twentyseventeen 
​
   cd $here/
   wp plugin install relevanssi --activate
   wp plugin install siteorigin-panels --activate
   wp plugin install black-studio-tinymce-widget --activate
   wp plugin install widget-context --activate
   wp plugin install better-wp-security --activate
​
   cd $here
   wp theme activate quest-child
   
   cd $here
   wp plugin activate drs-tk
​
​
#  Toggling the quest-child theme activation. Needed for it to work properly.
  
   cd $here
   wp theme activate quest
   wp theme activate quest-child
​
else
    echo "This is *NOT* the intended site you wanted."
fi


