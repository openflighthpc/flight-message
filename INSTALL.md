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
