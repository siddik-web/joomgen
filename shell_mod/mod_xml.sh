#!/bin/bash
date=`date +%Y-%m-%d`

#functions
create_manifest_xml() {
    mName="$1"; cDate="$date"; author="$2"; aEmail="$3"; aUrl="$4"; copy="$5"; license="$6"; version="$7"; desc="$8";
    name_uca="$(tr a-z A-Z <<<${mName})"
    

    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<extension version=\"3.3\" type=\"module\" client="site" method=\"upgrade\">
  <name>${mName}</name>
  <creationDate>${cDate}</creationDate>
  <author>${author}</author>
  <authorEmail>${aEmail}</authorEmail>
  <authorUrl>${aUrl}</authorUrl>
  <copyright>${copy}</copyright>
  <license>${license}</license>
  <version>${version}</version>
  <description>${desc}</description>

  <files>
    <filename module=\"${mName}\">${mName}.php</filename>
    <filename>helper.php</filename>
    <folder>assets</folder>
    <folder>language</folder>
    <folder>tmpl</folder>
  </files>

  <languages>
    <language tag=\"en-GB\">language/en-GB.mod_${mName}.ini</language>
  </languages>

</extension>
    "
}
directory=$1
cName=$2
(umask 077 ; touch "${directory}/${cName}.xml")
(create_manifest_xml "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" > "${directory}/${cName}.xml")