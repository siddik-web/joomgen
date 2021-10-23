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
controller_singular() {
    
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
use Joomla\CMS\MVC\Controller\FormController;

class ${component_ucf}Controller${singular_ucf} extends FormController
{
	public function getModel(\$name = '${singular_ucf}', \$prefix = '${component_ucf}Controller', \$config = array('ignore_request' => true))
	{
		\$model = parent::getModel(\$name, \$prefix, \$config); 

		return \$model; 
	}
	
}
    "
}
controller_plural() {
    
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

use Joomla\CMS\MVC\Controller\FormController;

class ${component_ucf}Controller${plural_ucf} extends FormController
{
	public function __construct(\$config = array())
	{
		parent::__construct(\$config);
	}
}
    "
}

(umask 077 ; touch "${directory}/${vSingular}.php")
(controller_singular > "${directory}/${vSingular}.php")
echo "${directory}/${vSingular}.php created."

(umask 077 ; touch "${directory}/${vPlural}.php")
(controller_plural > "${directory}/${vPlural}.php")
echo "${directory}/${vPlural}.php created."
