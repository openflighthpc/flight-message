# Flight Message

System for handling asset notifications

## Overview

Flight Message is a system for storing, reaping and displaying held messages from
cluster assets.

## Installation

For installation instructions please see INSTALL.md

## Configuration

Please use `init-cluster MY_CLUSTER` before operation to specify the name of your
cluster

## Operation
o
Messages are pieces of information about a cluster. They relate to a single asset
and each contain some descriptive text.
They can be one of two types: 'status' and 'information'. Status messages are
intended to simply describe the current state of the  asset - if it is online,
offline, degraded etc. Only one 'status' is valid at a time. Information messages
contain some permanent information on the asset e.g. that a fault was detected.
Additionally each message has a creation time, a unique ID and some have a time
of expiry.

The messages should be frequently reaped. A reap removes all but the most recent
'status' message and all messages that have exceeded their expiry.

Flight Message uses concept of clusters. Messages belong to an asset which belong
to a cluster. One cluster is selected at a given time and clusters can be created,
swapped out and deleted.

### Commands

```

create TYPE ASSET TEXT [-l LIFESPAN]

delete ID

show

init-cluster CLUSTER

list-cluster

switch-cluster CLUSTER

delete-cluster CLUSTER

```

`create` - create a new message of type either 'information' or 'status' for the
specified asset with the given message. Additionally a lifespan can be specified,
some amount of minutes (m), hours (h), and days (d).

`delete` - deletes the message with the given ID.

`show` - displays the status and any information about each asset.

`init-cluster` - creates a new cluster to work on and selects it.

`list-cluster` - displays all clusters that have been initialised and which
cluster is currently selected.

`switch-cluster` - selects the given cluster.

`delete-cluster` - deletes the given cluster and all its messages.

Additionally there is a hidden 'reap' command for clearing out the store.
It is automatically called on the current cluster whenever 'show' is called.

# Contributing

Fork the project. Make your feature addition or bug fix. Send a pull
request. Bonus points for topic branches.

Read [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

# Copyright and License

Eclipse Public License 2.0, see [LICENSE.txt](LICENSE.txt) for details.

Copyright (C) 2019-present Alces Flight Ltd.

This program and the accompanying materials are made available under
the terms of the Eclipse Public License 2.0 which is available at
[https://www.eclipse.org/legal/epl-2.0](https://www.eclipse.org/legal/epl-2.0),
or alternative license terms made available by Alces Flight Ltd -
please direct inquiries about licensing to
[licensing@alces-flight.com](mailto:licensing@alces-flight.com).

Flight Message is distributed in the hope that it will be
useful, but WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER
EXPRESS OR IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR
CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR
A PARTICULAR PURPOSE. See the [Eclipse Public License 2.0](https://opensource.org/licenses/EPL-2.0) for more
details.
