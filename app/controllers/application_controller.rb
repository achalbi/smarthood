class ApplicationController < ActionController::Base
  layout Proc.new { |controller| controller.request.xhr? ? false : 'application' }

  protect_from_forgery
  include SessionsHelper
end
