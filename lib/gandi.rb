module Gandi
  class DataError < ArgumentError ; end
  class ServerError < RuntimeError ; end
end

require 'gandi/base'
require 'gandi/domain'
require 'gandi/version'
