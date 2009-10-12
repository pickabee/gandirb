module Gandi
  class DataError < ArgumentError ; end
  class ServerError < RuntimeError ; end
end

directory = File.expand_path(File.dirname(__FILE__))
 
require File.join(directory, 'gandi/base')
require File.join(directory, 'gandi/domain')
require File.join(directory, 'gandi/hosting')
