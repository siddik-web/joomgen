#!/bin/bash
date=`date`
year=`date +%Y`

component_name="$2"
author_name="$3"
email="$4"
url="$5"

#functions
create_legacyrouter_php() {
    cName="$1"
    cname_uca="$(tr a-z A-Z <<<${cName})"
    name_ucf="$(tr a-z A-Z <<< ${cName:0:1})${cName:1}"
    echo "
<?php
/**
* @package    	Joomla.Site
* @subpackage 	com_${component_name}
* @author 		${author_name} ${email}
* @copyright 	Copyright (c) 2010 - ${year} ${author_name} ${url}
* @license     	GNU General Public License version 2 or later; see http://www.gnu.org/licenses/gpl-2.0.html
*/

// No Direct Access
defined ('_JEXEC') or die('Restricted Access');

use Joomla\CMS\Factory;
use Joomla\CMS\Component\ComponentHelper;
use Joomla\CMS\Component\Router\Rules\RulesInterface;

class ${name_ucf}RouterRulesLegacy implements RulesInterface
{

	public function __construct(\$router)
	{
		\$this->router = \$router;
	}

	public function preprocess(&\$query)
	{
	}

	public function build(&\$query, &\$segments)
	{
		\$params 	= ComponentHelper::getParams('com_${cName}');
		\$advanced 	= \$params->get('sef_advanced_link', 0);

		if (empty(\$query['Itemid']))
		{
			\$menuItem 		= \$this->router->menu->getActive();
			\$menuItemGiven = false;
		}
		else
		{
			\$menuItem 		= \$this->router->menu->getItem(\$query['Itemid']);
			\$menuItemGiven = true;
		}

		// Check again
		if (\$menuItemGiven && isset(\$menuItem) && \$menuItem->component != 'com_${cName}')
		{
			\$menuItemGiven = false;
			unset(\$query['Itemid']);
		}

		

		if (isset(\$query['view']))
		{
			\$view = \$query['view'];
		}
		else
		{
			// We need to have a view in the query or it is an invalid URL
			return;
		}


		if (\$menuItem !== null
		&& isset(\$menuItem->query['view'], \$query['view'], \$menuItem->query['id'], \$query['id'])
		&& \$menuItem->query['view'] == \$query['view']
		&& \$menuItem->query['id'] == (int) \$query['id'])
		{
			unset(\$query['view']);

			if (isset(\$query['catid']))
			{
				unset(\$query['catid']);
			}

			if (isset(\$query['layout']))
			{
				unset(\$query['layout']);
			}

			unset(\$query['id']);

			return;
		}

        foreach(\$segments as \$i => &\$segment)
		{
			\$segment = str_replace(':', '-', \$segment);
		}
    }

    public function parse(&\$segments, &\$vars)
	{
		\$total = count(\$segments);

		for (\$i = 0; \$i < \$total; \$i++)
		{
			\$segments[\$i] = preg_replace('/-/', ':', \$segments[\$i], 1);
		}

		// Get the active menu item.
		\$item 		= \$this->router->menu->getActive();
		\$params 	= ComponentHelper::getParams('com_${cName}');
		\$advanced 	= \$params->get('sef_advanced_link', 0);
		\$db 		= Factory::getDbo();

		// Count route segments
		\$count = count(\$segments);

		if (!isset(\$item))
		{
			\$vars['view'] 	= \$segments[0];
			\$vars['id']	= \$segments[\$count - 1];

			return;
		}
    }
}
    "
}
directory=$1
cName=$2
(umask 077 ; touch "${directory}/legacyrouter.php")
(create_legacyrouter_php "$cName" > "${directory}/legacyrouter.php")
