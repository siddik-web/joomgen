#!/bin/bash
date=`date`
year=`date +%Y`


#functions
create_component_php() {
    cName="$1"
    cname_uca="$(tr a-z A-Z <<<${cName})"
    name_ucf="$(tr a-z A-Z <<< ${cName:0:1})${cName:1}"
    echo "
<?php
/**
* @package com_${cName}
* @author JoomShaper http://www.joomshaper.com
* @copyright Copyright (c) 2010 - ${year} JoomShaper
* @license http://www.gnu.org/licenses/gpl-2.0.html GNU/GPLv2 or later
*/

// No Direct Access
defined ('_JEXEC') or die('Restricted Access');

use Joomla\CMS\Language\Text;
use Joomla\CMS\Factory;
use Joomla\CMS\Uri\Uri;
use Joomla\CMS\MVC\Controller\BaseController;

if(file_exists(JPATH_COMPONENT.'/vendor/autoload.php'))
{
  include JPATH_COMPONENT.'/vendor/autoload.php';
}

if(!JFactory::getUser()->authorise('core.manage','com_${cName}'))
{
  return JError::raiseWarning(404,Text::_('JERROR_ALERTNOAUTHOR'));
}

if(file_exists(JPATH_COMPONENT.'/helpers/${cName}.php'))
{
  JLoader::register('${name_ucf}Helper', JPATH_COMPONENT . '/helpers/${cName}.php');
}

//Load basic css file

\$doc = Factory::getDocument();
\$doc->addStyleSheet(Uri::root(true) . '/administrator/components/com_${cName}/assets/css/style.css');

// Execute the task.
\$controller = BaseController::getInstance('${name_ucf}');
\$controller->execute(Factory::getApplication()->input->get('task'));
\$controller->redirect();
    "
}
directory=$1
cName=$2
(umask 077 ; touch "${directory}/${cName}.php")
(create_component_php "$cName" > "${directory}/${cName}.php")
