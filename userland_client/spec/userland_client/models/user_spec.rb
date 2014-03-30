require 'spec_helper'

describe UserlandClient::User do

  describe "#login" do
    it "passes the request back to userland" do
      login = "Hello"
      password = "World"

      expect(UserlandClient::Userland).to receive(:get).
        with('/users/login', body: {login: login, password: password}).
        and_return(double("fakey", code: true))
      UserlandClient::User.login(login, password)
    end

    it "returns nil on an invalid login" do
      expect(UserlandClient::Userland).to receive(:get).and_return(double("response", code: 404))
      non_user = UserlandClient::User.login("Hi", "There")
      expect(non_user).to be_nil
    end

    it "returns a User on valid login" do
      response = {
        'id'         => 4,
        'login'      => 'Dude',
        'password'   => 'Awesome',
        'created_at' => '2013-12-07T17:11:45.518Z',
        'updated_at' => '2013-12-07T17:11:45.518Z'
      }
      expect(response).to receive(:code).and_return(200)
      expect(UserlandClient::Userland).to receive(:get).and_return(response)
      user = UserlandClient::User.login("Hi", "There")
      expect(user).to_not be_nil
      expect(user.id).to eq(4)
      expect(user.login).to eq('Dude')
      expect(user.password).to eq('Awesome')
      expect(user.created_at.hour).to eq(17)
      expect(user.created_at.min).to eq(11)
    end
  end
end
