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

require 'time'

module FlightMessage
  module Commands
    class Reap < Command
      def run
        Dir.glob(File.join(Config.store_dir, '*', '*')).each do |asset_dir|
          messages = Dir[File.join(asset_dir, '*')].map do |p|
            message = Message.new(File.basename(p))
            message.load_from_id
            message
          end

          messages.delete_if do |m|
            if m.data['expiry'] and m.data['expiry'] < Time.now.iso8601
              File.delete(m.path)
            end
          end

          statuses = messages.select { |m| m.data['type'] == 'status' }
          statuses = statuses.sort_by { |m| m.data['received'] }
          # delete all but the most recent
          statuses.pop
          statuses.each { |m| File.delete(m.path) }
        end
      end
    end
  end
end
