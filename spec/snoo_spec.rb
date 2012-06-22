require 'snoo'
require_relative 'auth'

describe Snoo::Client do
  before :all do
      @client = Snoo::Client.new
      @client.log_in $testuser, $testpass
  end

  describe "#new" do
    after :each do
      sleep 2
    end
    it "Creates a new Snoo::Client object" do
      Snoo::Client.new.should be_an_instance_of(Snoo::Client)
    end
    it "Creates an unauthorized Snoo::Client" do
      client = Snoo::Client.new
      client.modhash.should be_nil
      client.username.should be_nil
      client.userid.should be_nil
      client.cookie.should be_nil
    end
  end

  describe "Account" do
    after :each do
      sleep 2
    end

    # Due to the constraints the reddit API provides us, we only log in once, and then use it as much as we can.
    describe "#log_in" do
      it "logs in and ensures all the instance variables are set" do
        @client.modhash.should_not be_nil
        @client.userid.should_not be_nil
        @client.username.should_not be_nil
        @client.cookie.should_not be_nil
      end
    end

    describe "#clear_sessions" do
      it "clears other sessions and looks for 'all other sessions have been cleared' from the server" do
        response = @client.clear_sessions $testpass
        response['jquery'][14][3][0].should eq"all other sessions have been logged out"
      end
    end

    describe "#me" do
      it "gets info about currently logged in user, and makes sure this matches $testuser" do
        me = @client.me
        me['data']['name'].should eq $testuser
      end
    end
  end

  describe "Flair" do
    after :each  do
      sleep 2
    end
    describe "#clear_flair_templates" do
      after :each do
        sleep 2
      end
      it "clears user flair templates" do
        @client.clear_flair_templates('USER_FLAIR', $testreddit).code.should eq 200
      end
      it "clears link flair templates" do
        @client.clear_flair_templates('LINK_FLAIR', $testreddit).code.should eq 200
      end
    end

    describe "#flair" do
      it "sets user flair on this user" do
        flair = @client.flair $testreddit, css_class: "test", text: "test", name: $testuser
        flair.code.should eq 200
      end
    end

    describe "#delete_user_flair" do
      it "deletes user flair from this user" do
        @client.delete_user_flair($testuser, $testreddit).code.should eq 200
      end
    end

    describe "#get_flair_list" do
      it "should get a list of flair" do
        @client.get_flair_list($testreddit).code.should eq 200
      end
    end
  end

  describe "Listings" do
    after :each do
      sleep 2
    end
    describe "#get_listing" do
      it "gets a listing of links from reddit" do
        listing = @client.get_listing subreddit: $testreddit
        listing.code.should eq 200
      end
    end
    describe "#search" do
      it "searches reddit for 'test'" do
        search = @client.search 'test'
        search.code.should eq 200
      end
    end
  end

  describe "Private Messages" do
    after :each do
      sleep 2
    end
    describe "#send_pm" do
      it "should send a private message to current user" do
        send = @client.send_pm $testuser, 'test', 'testing'
        send.code.should eq 200
      end
    end
    describe "#get_messages" do
      it "should get a list of private messages" do
        messages = @client.get_messages
        messages.code.should eq 200
      end
    end
  end

  describe "User" do
    after :each do
      sleep 2
    end

    describe "#get_friends" do
      it "should get a list of friends" do
        friends = @client.get_friends
        friends.code.should eq 200
      end
    end

    describe "#get_user_info" do
      it "should get information about the current user account" do
        info = @client.get_user_info $testuser
        info.code.should eq 200
      end
    end

    describe "#get_user_listing" do
      it "should get a listing of user's posts" do
        listing = @client.get_user_listing $testuser
        listing.code.should eq 200
      end
    end
  end

  describe "#log_out" do
    it "logs out and sets instance variables to nil" do
      @client.log_out
      @client.modhash.should be_nil
      @client.userid.should be_nil
      @client.username.should be_nil
      @client.cookie.should be_nil
    end
  end
end
