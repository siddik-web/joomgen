#!/bin/bash
date=`date`
year=`date +%Y`

author_name="$3"
email="$4"
url="$5"

#functions
create_mod_helper() {
    cName="$1"
    cname_uca="$(tr a-z A-Z <<<${cName})"
    name_ucf="$(tr a-z A-Z <<< ${cName:0:1})${cName:1}"
    echo "
<?php
/**
* @package    	Joomla.Site
* @subpackage 	com_${cName}
* @author 		${author_name} ${email}
* @copyright 	Copyright (c) 2010 - ${year} ${author_name} ${url}
* @license      GNU General Public License version 2 or later; see http://www.gnu.org/licenses/gpl-2.0.html
*/

// No Direct Access
defined ('_JEXEC') or die('Restricted Access');

class ${name_ucf}Helper
{
	//Debugging function. Removed in the production package
	public static function debug(\$data, \$die = true)
    {
		echo \"<pre>\"; print_r(\$data); echo \"</pre>\"; if(\$die)die;
	}
}

    "
}
directory=$1
cName=$2
(umask 077 ; touch "${directory}/${cName}.php")
(create_mod_helper "$cName" > "${directory}/${cName}.php")
