#!/bin/bash
date=`date`
year=`date +%Y`

directory="$1"
component_name="$2"
vSingular="$3"
vPlural="$4"
author_name="$5"
email="$6"
copyright="$7"

component_ucf="$(tr a-z A-Z <<< ${component_name:0:1})${component_name:1}"
component_uca="$(tr a-z A-Z <<<${component_name})"
singular_ucf="$(tr a-z A-Z <<< ${vSingular:0:1})${vSingular:1}"
singular_uca="$(tr a-z A-Z <<< ${vSingular})"
plural_ucf="$(tr a-z A-Z <<< ${vPlural:0:1})${vPlural:1}"
plural_uca="$(tr a-z A-Z <<< ${vPlural})"

#functions
default_view_singular() {
    
    echo "
<?php
/**
* @package    	Joomla.Site
* @subpackage 	com_${component_name}
* @author 		${author_name} ${email}
* @copyright 	${copyright}
* @license     	GNU General Public License version 2 or later; see http://www.gnu.org/licenses/gpl-2.0.html
*/

// No Direct Access
defined ('_JEXEC') or die('Restricted Access');

?>
<h4>Detail View</h4>
<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Nobis, exercitationem inventore quod facilis laudantium ut minus molestiae reiciendis. Esse consectetur sunt suscipit numquam quos sint blanditiis distinctio labore quaerat fuga?</p>
"
}
default_view_plural() {
    
    echo "
<?php
/**
* @package    	Joomla.Site
* @subpackage 	com_${component_name}
* @author 		${author_name} ${email}
* @copyright 	${copyright}
* @license     	GNU General Public License version 2 or later; see http://www.gnu.org/licenses/gpl-2.0.html
*/

// No Direct Access
defined ('_JEXEC') or die('Restricted Access');

?>
<h4>List View</h4>
<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Nobis, exercitationem inventore quod facilis laudantium ut minus molestiae reiciendis. Esse consectetur sunt suscipit numquam quos sint blanditiis distinctio labore quaerat fuga?</p>
"
}

default_xml() {
    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<metadata>
	<fields name=\"params\" addfieldpath=\"/components/com_${component_name}/fields\">
		<fieldset name=\"basic\" label=\"COM_${component_uca}_VIEW_MENU_OPTIONS\"></fieldset>
	</fields>
</metadata>
    " 
}

singularView="${directory}/${vSingular}/tmpl"
pluralView="${directory}/${vPlural}/tmpl"

mkdir -p "${singularView}"
echo "${singularView} created" 
mkdir -p "${pluralView}"
echo "${pluralView} created" 

(umask 077 ; touch "${singularView}/default.php")
(default_view_singular > "${singularView}/default.php")
echo "${directory}/default.php created."

(umask 077 ; touch "${pluralView}/default.php")
(default_view_plural > "${pluralView}/default.php")
echo "${directory}/default.php created."

(umask 077 ; touch "${pluralView}/default.xml")
(default_xml > "${pluralView}/default.xml")
echo "${directory}/default.xml created."
