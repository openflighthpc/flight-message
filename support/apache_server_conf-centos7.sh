#!/bin/bash

yum -y install httpd php

cat << EOF > /etc/httpd/conf.d/collector.conf
<Directory /opt/flight/opt/message/export/>
     Options Indexes MultiViews
     AllowOverride None
     Require all granted
     Order Allow,Deny
     Allow from 10.10.0.0/16
     Allow from 127.0.0.1/8
</Directory>
Alias /message /opt/flight/opt/message/export
EOF

mkdir -p /opt/flight/opt/message/export/exec

cat << 'EOF' > /opt/flight/opt/message/export/exec/create_status.php
<?php
$text = "OK";
$keys = array_keys($_GET);
/* starting at index 1 as 'asset' is expected to be the first elem */
for($i=1; $i < count($_GET); ++$i) {
  $text .= " | {$keys[$i]} = {$_GET[$keys[$i]]}";
}
$cmd = "sudo /opt/flight/bin/flight message create status {$_GET['asset']} \"{$text}\" --lifespan 1h";
echo exec(escapeshellcmd($cmd));
?>
EOF

echo "apache ALL=(ALL) NOPASSWD: /opt/flight/bin/flight" >> /etc/sudoers

sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

setenforce 0

systemctl enable httpd
systemctl restart httpd
