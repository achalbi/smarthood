require "spec_helper"

describe SConcernsController do
  describe "routing" do

    it "routes to #index" do
      get("/s_concerns").should route_to("s_concerns#index")
    end

    it "routes to #new" do
      get("/s_concerns/new").should route_to("s_concerns#new")
    end

    it "routes to #show" do
      get("/s_concerns/1").should route_to("s_concerns#show", :id => "1")
    end

    it "routes to #edit" do
      get("/s_concerns/1/edit").should route_to("s_concerns#edit", :id => "1")
    end

    it "routes to #create" do
      post("/s_concerns").should route_to("s_concerns#create")
    end

    it "routes to #update" do
      put("/s_concerns/1").should route_to("s_concerns#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/s_concerns/1").should route_to("s_concerns#destroy", :id => "1")
    end

  end
end
