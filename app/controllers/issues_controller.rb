class IssuesController < ApplicationController
  def new

  end

  def create
  	
  end

  def index
  	@issue = IssueTracker.new
  	@issues = IssueTracker.all
  end

  def show
  	
  end

  def update
  	
  end

end
