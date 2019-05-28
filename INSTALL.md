# Installing Flight Message

## Generic

Flight Message requires a recent version of `ruby` (2.5.1<=) and `bundler`.
The following will install from source using `git`:
```
git clone https://github.com/openflighthpc/flight-message.git
cd flight-message
bundle install
```

The entry script is located at `bin/message`

## Installing with Flight Runway

Flight Runway provides the Ruby environment and command-line helpers for running openflightHPC tools.

To install Flight Runway, see the [Flight Runway installation docs](https://github.com/openflighthpc/flight-runway#installation).

These instructions assume that `flight-runway` has been installed from the openflightHPC yum repository and [system-wide integration](https://github.com/openflighthpc/flight-runway#system-wide-integration) enabled.

Install Flight Message:

```
[root@myhost ~]# yum -y install flight-message
```

Flight Message is now available via the `flight` tool::

```
[root@myhost ~]# flight message
  NAME:

    flight message

  DESCRIPTION:

    Asset notification handling system

  COMMANDS:

    create         Create a new message
    delete         Delete an existing message
    delete-cluster Remove a cluster
    <snip>
```

Then, if you wish to set up Message as a server you will need to run:

```
./support/apache_server_conf-centos7.sh
```

As the name might suggest, this has only been tested on CentOS7.

## One line install

Additionally, there is a single line install available for blank CentOS 7 machines that handles the
installation of Flight Runway, Flight Message and sets up the machine as an Apache server for handling
requests from a private network.

```
curl https://raw.githubusercontent.com/openflighthpc/flight-message/master/support/install-centos7.sh | bash
```

# Setting up clients

There is also a one line curl for setting up a machine as a client, sending power information to flight message once and hour. That line is:

```
curl https://raw.githubusercontent.com/openflighthpc/flight-message/master/support/setup-client.sh | bash -s IP_OF_SERVER
```

Where 'IP_OF_SERVER' is the address of the the server machine, set up as above.

# Testing

The following section assumes you have a working [Vagrant](https://www.vagrantup.com/) installation.

In the project's root directory there is a Vagrantfile for the setup of a test environment. To enable it as a server simply:

```
cd flight-message
vagrant up
```
During this process you will need to select the correct network interface for your machine.
At the end of the output during this process the new machine's `ip addr` data will be displayed. Contained in this is the machine's public network IP address.

In the (likely) case that your network isn't on the 10.10 range you will need to:

```
vagrant ssh
sudo -s
vi /opt/flight/opt/message/support/apache_server_conf-centos7.sh
```

From here change the `Allow from 10.10.0.0/16` line to a subnet mask valid for your network.
More information on subnet masks [here](https://www.iplocation.net/subnet-mask). Then save the file, exit it, and:

```
chmod 744 /opt/flight/opt/message/support/apache_server_conf-centos7.sh
/opt/flight/opt/message/support/apache_server_conf-centos7.sh
exit
exit
```

The vagrant machine will now be respond to requests just remember to `export FLIGHT_MESSAGE_SERVER=<YOUR_IP>` before executing collector scripts.

