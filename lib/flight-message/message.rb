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

require 'flight-message/config'
require 'flight-message/exceptions'
require 'flight-message/utils'

require 'fileutils'
require 'securerandom'
require 'time'

module FlightMessage
  class Message
    class << self
      def find(id)
        glob = Dir.glob(File.join(Config.store_dir, '**', id))

        if glob.length == 1
          return glob[0]
        else
          return nil
        end
      end

      def split_path(path)
        if m = path.match(/^#{Config.store_dir}\/(.*)\/(.*)\/(.*$)/)
          return m[1..3]
        else
          raise MessageError, 'Internal error - unable to split invalid path'
        end
      end
    end

    attr_reader :id

    TYPES = ['status', 'information']

    def initialize(id = SecureRandom.uuid)
      @id = id
    end

    def create(type, asset, text, cluster = Config.default_cluster, lifespan = nil)
      unless TYPES.include?(type)
        raise ArgumentError, "Unknown message type '#{type}'"
      end
      @asset = asset
      @cluster = cluster
      data['type'] = type
      data['text'] = text
      data['received'] = Time.now.iso8601
    end

    def load_from_id(id = @id)
      unless path = Message.find(id)
        raise MessageError, "Internal error - unable to load message '#{id}'"
      end
      @cluster, @asset, _ = Message.split_path(path)
      self.data
    end

    def data
      @data = if @data
                @data
              elsif File.file?(path)
                read
              else
                {}
              end
    end

    def path
      unless @asset and @cluster
        raise MessageError, 'Internal error - asset & cluster not set on message'
      end
      File.join(Config.store_dir, @cluster, @asset, @id)
    end

    def read
      Utils.load_yaml(path)
    end

    def save
      FileUtils.mkdir_p(File.dirname(path))
      yaml = data.to_yaml
      File.open(path, 'w') { |f| f.write(yaml) }
    end
  end
end
