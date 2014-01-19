class Address < ActiveRecord::Base
  attr_accessible :city, :country, :doorno, :postalcode, :state, :street
end
