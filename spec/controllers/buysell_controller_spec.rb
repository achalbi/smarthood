require 'spec_helper'

describe BuysellController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'index--no-test-framework'" do
    it "returns http success" do
      get 'index--no-test-framework'
      response.should be_success
    end
  end

end
