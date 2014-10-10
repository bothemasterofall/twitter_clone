require 'spec_helper'

RSpec.describe PagesController, :type => :controller do

  render_views
  
  before(:each) do
	@base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      expect(response).to be_success
    end
	
	it "should have the right title" do
		get 'home'
		response.should have_selector("title", :content => "#{@base_title} | Home")
	end
	
	it "should not have a non-blank body" do
		get 'home'
		response.body.should_not =~ /<body>\s*<body\/body>/
	end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      expect(response).to be_success
    end
	
	it "should have the right title" do
		get 'contact'
		response.should have_selector("title",
			:content => "#{@base_title} | Contact")
	end
  end
  
  describe "GET 'about'" do
	it "returns http success" do
      get 'about'
      expect(response).to be_success
    end
	
	it "should have the right title" do
		get 'about'
		response.should have_selector("title",
			:content => "#{@base_title} | About")
	end
  end
end
