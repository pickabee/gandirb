require 'test_helper'

class GandiTest < ActiveSupport::TestCase
  
  should "define custom errors mapping Gandi error codes" do
    assert Gandi::DataError.ancestors.include? ArgumentError
    assert Gandi::ServerError.ancestors.include? RuntimeError
  end
end
