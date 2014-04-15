require 'spec_helper'

module UserlandClient

  describe User do

    def stub_out_get_request
      response = {
        'id'         => 4,
        'login'      => 'Dude',
        'password'   => 'Awesome',
        'created_at' => '2013-12-07T17:11:45.518Z',
        'updated_at' => '2013-12-07T17:11:45.518Z'
      }
      expect(response).to receive(:code).and_return(200)
      expect(UserlandAdapter).to receive(:get).and_return(response)
    end

    describe "#to_json" do
      it "represents the user as json" do
        t = Time.now
        u = User.new(
          id:         5,
          login:      'hi',
          password:   'there',
          created_at: t,
          updated_at: t
        )

        expect(JSON.parse(u.to_json)).to eq({
          'id'         => 5,
          'login'      => 'hi',
          'password'   => 'there',
          'created_at' => t.to_s,
          'updated_at' => t.to_s
        })
      end
    end

    describe "#login" do
      it "passes the request back to userland" do
        login = "Hello"
        password = "World"

        expect(UserlandAdapter).to receive(:get).
          with("#{User::BASEPATH}/login", body: {login: login, password: password}).
          and_return(double("fakey", code: true))
        User.login(login, password)
      end

      it "returns nil on an invalid login" do
        expect(UserlandAdapter).to receive(:get).and_return(double("response", code: 404))
        non_user = User.login("Hi", "There")
        expect(non_user).to be_nil
      end

      it "returns a User on valid login" do
        stub_out_get_request
        user = User.login("Hi", "There")
        expect(user).to_not be_nil
        expect(user.id).to eq(4)
        expect(user.login).to eq('Dude')
        expect(user.password).to eq('Awesome')
        expect(user.created_at.hour).to eq(17)
        expect(user.created_at.min).to eq(11)
      end
    end

    it "allows updating users" do
      stub_out_get_request
      u = User.login("hi", "there")
      expect(u.login).to eq('Dude')
      u.login = 'Changed'
      expect(UserlandAdapter).to receive(:post).with("#{User::BASEPATH}/#{u.id}", body: u.to_json).and_return(true)
      expect(u.save).to be_true
    end

    context "integration tests, for end-to-end", integration: true do
      pending
      context "http" do
        it "retrieves a user" do
          UserlandAdapter.configure do |c|
            c.transport = HTTParty
            c.hostname  = 'localhost:3000'
            c.protocol  = 'http'
          end

          user = User.login("Hi", "There")
          expect(user).to_not be_nil
        end
      end

      context "amqp" do
        it "retrieves a user" do
          UserlandAdapter.configure do |c|
            c.transport = AMQParty
            c.queue     = 'userland'
            c.protocol  = 'amqp'
          end
          user = User.login("Hi", "There")
          expect(user).to_not be_nil
        end
      end
    end
  end
end
