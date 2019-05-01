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
require 'flight-message/commands'
require 'flight-message/version'

require 'commander'

module FlightMessage
  module CLI
    PROGRAM_NAME = ENV.fetch('FLIGHT_PROGRAM_NAME','message')

    extend Commander::Delegates
    program :application, "Flight Message"
    program :name, PROGRAM_NAME
    program :version, "Release 2019.1 (v#{FlightMessage::VERSION})"
    program :description, 'Asset notification handling system'
    program :help_paging, false
    default_command :help
    silent_trace!

    class << self
      def cli_syntax(command, args_str = nil)
        command.syntax = [
          PROGRAM_NAME,
          command.name,
          args_str
        ].compact.join(' ')
       end

      def add_cluster_option(command)
        command.option '-c', '--cluster CLUSTER',
          'Specify a cluter (defaults to the value set in the config file)'
      end
    end

    command :create do |c|
      cli_syntax(c, 'TYPE ASSET TEXT')
      c.description = "Create a new message"
      add_cluster_option(c)
      c.action(Commands, :create)
    end

    command :show do |c|
      cli_syntax(c)
      c.description = "Show the status of all assets"
      add_cluster_option(c)
      c.action(Commands, :show)
    end

    command :delete do |c|
      cli_syntax(c, 'ID')
      c.description = "Delete an existing message"
      c.action(Commands, :delete)
    end

    command :reap do |c|
      cli_syntax(c)
      c.hidden = true
      c.description = "Remove all messages that have been made obselete"
      c.action(Commands, :reap)
    end
  end
end
