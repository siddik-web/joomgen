#!/bin/bash
date=`date`
year=`date +%Y`

component_name="$2"
author_name="$3"
email="$4"
url="$5"

#functions
create_installer_script_php() {
    cName="$1"
    cname_uca="$(tr a-z A-Z <<<${cName})"
    cname_ucf="$(tr a-z A-Z <<< ${cName:0:1})${cName:1}"
    echo "
    <?php
/**
* @package    	Joomla.Administrator
* @subpackage 	com_${component_name}
* @author 		${author_name} ${email}
* @copyright 	Copyright (c) 2010 - ${year} ${author_name} ${url}
* @license      GNU General Public License version 2 or later; see http://www.gnu.org/licenses/gpl-2.0.html
*/

// No Direct Access
defined ('_JEXEC') or die('Restricted Access');

use Joomla\CMS\Factory;
use Joomla\CMS\Installer\Installer;

class com_${cName}InstallerScript
{

    public function uninstall(\$parent)
    {

        \$extensions = array(
            array('type'=>'module', 'name'=>'module_name'),
            array('type'=>'plugin', 'name'=>'plugin_name')
        );

        foreach (\$extensions as \$key => \$extension)
        {
            \$db = Factory::getDbo();         
            \$query = \$db->getQuery(true);         
            \$query->select(\$db->quoteName(array('extension_id')));
            \$query->from(\$db->quoteName('#__extensions'));
            \$query->where(\$db->quoteName('type') . ' = '. \$db->quote(\$extension['type']));
            \$query->where(\$db->quoteName('element') . ' = '. \$db->quote(\$extension['name']));
            \$db->setQuery(\$query); 
            \$id = \$db->loadResult();

            if(isset(\$id) && \$id)
            {
                \$installer = new Installer;
                \$result = \$installer->uninstall(\$extension['type'], \$id);
            }
        }
    }

    function postflight(\$type, \$parent)
    {
        \$extensions = array(
            array('type'=>'module', 'name'=>'module_name'),
            array('type'=>'plugin', 'name'=>'plugin_name', 'group'=>'system')
        );

        foreach (\$extensions as \$key => \$extension)
        {
            \$ext = \$parent->getParent()->getPath('source') . '/' . \$extension['type'] . 's/' . \$extension['name'];
            \$installer = new Installer;
            \$installer->install(\$ext);

            if(\$extension['type'] == 'plugin')
            {
                \$db = Factory::getDbo();
                \$query = \$db->getQuery(true); 
                
                \$fields = array(\$db->quoteName('enabled') . ' = 1');
                \$conditions = array(
                    \$db->quoteName('type') . ' = ' . \$db->quote(\$extension['type']), 
                    \$db->quoteName('element') . ' = ' . \$db->quote(\$extension['name']),
                    \$db->quoteName('folder') . ' = ' . \$db->quote(\$extension['group'])
                    );

                \$query->update(\$db->quoteName('#__extensions'))->set(\$fields)->where(\$conditions); 
                \$db->setQuery(\$query);
                \$db->execute();
            }
        }
    }
}
    "
}
directory=$1
cName=$2
(umask 077 ; touch "${directory}/installer.script.php")
(create_installer_script_php "$cName" > "${directory}/installer.script.php")
