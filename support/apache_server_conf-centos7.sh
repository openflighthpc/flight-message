#!/bin/bash
# =============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
#
# This file is part of Flight Message.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Message is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Message. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight Message, please visit:
# https://github.com/openflighthpc/flight-message
# ==============================================================================

yum -y install httpd php syslinux

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
$extra = "";
$keys = array_keys($_GET);
/* starting at index 1 as 'asset' is expected to be the first elem */
for($i=1; $i < count($_GET); ++$i) {
  $extra .= " \"{$keys[$i]}\"=\"{$_GET[$keys[$i]]}\"";
}
$cmd = "sudo /opt/flight/bin/flight message create status {$_GET['asset']} OK {$extra} --lifespan 1h";
echo exec(escapeshellcmd($cmd));
?>
EOF

echo "apache ALL=(ALL) NOPASSWD: /opt/flight/bin/flight" >> /etc/sudoers

sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

setenforce 0

systemctl enable httpd
systemctl restart httpd
