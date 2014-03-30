require 'spec_helper'

module UserlandClient # TODO decide if this is kosher
  describe Userland do
    after :each do
      Userland.configuration = nil
    end

    describe "#configuration" do
      it "allows configuration by options block" do
        x = nil
        Userland.configure do |config|
          x = config
        end
        expect(x).to_not be_nil
      end

      it "allows transport definition" do
        Userland.configure do |config|
          config.transport = HTTParty
        end
        expect(Userland.configuration.transport).to eq(HTTParty)
      end
    end

    describe "#get" do
      let(:mock_transport) { double }
      before :each do
        Userland.configure{|c| c.transport = mock_transport }
      end
      it "transmits the message along the appropriate transport" do
        path = 'some_path'
        args = {body: {param: 'value'}}
        expect(mock_transport).to receive(:get).with(path, args)
        Userland.get(path, args)
      end
    end
  end
end
