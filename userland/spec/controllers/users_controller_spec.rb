require 'spec_helper'

describe UsersController do
  describe "#login" do
    before :all do
      @valid_user = User.create(login: 'hello', password: 'world')
    end
    after :all do
      @valid_user.destroy
    end

    it "responds with 401 when an invalid user is used" do
      get :login, login: 'foo', password: 'bar'
      expect(response.status).to eq(401)
    end

    it "responds with 200 and the user json when a valid user is used" do
      get :login, login: @valid_user.login, password: @valid_user.password
      expect(response.status).to eq(200)
      expect(response.body).to eq(@valid_user.to_json)
    end
  end
end
