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

require 'flight-message/command'
require 'flight-message/config'

module FlightMessage
  module Commands
    class Delete < Command
      def run
        glob = Dir.glob(File.join(Config.store_dir, '**', @argv[0]))
        if glob.length == 1
          File.delete(glob[0])
          p "'#{File.expand_path(glob[0])}' has been deleted"
        else
          p "No message found for uuid '#{@argv[0]}'"
        end
      end
    end
  end
end
