# Copyright 2015 ThoughtWorks, Inc.

# This file is part of Gauge-Ruby.

# Gauge-Ruby is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Gauge-Ruby is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Gauge-Ruby.  If not, see <http://www.gnu.org/licenses/>.

require 'protocol_buffers'
require_relative 'api_pb'

module Gauge
  # @api private
  module Connector
    GAUGE_PORT_ENV = "GAUGE_INTERNAL_PORT"
    HOST_NAME = '127.0.0.1'
    @@executionSocket = nil


    def self.execution_socket
      @@executionSocket
    end

    def self.make_connection
      @@executionSocket = TCPSocket.open(HOST_NAME, Runtime.port_from_env_variable(GAUGE_PORT_ENV))
      @@executionSocket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
    end

    def self.message_length(socket)
      ProtocolBuffers::Varint.decode socket
    end

    def self.step_value text
      return text.gsub(/(<.*?>)/, "{}")
    end
  end
end
