require 'spec_helper'

module UserlandClient # TODO decide if this is kosher
  describe UserlandAdapter do
    after :each do
      UserlandAdapter.configuration = nil
    end

    describe "#configuration" do
      it "allows configuration by options block" do
        x = nil
        UserlandAdapter.configure do |config|
          x = config
        end
        expect(x).to_not be_nil
      end

      %w{transport hostname protocol queue}.each do |definable|
        it "allows #{definable} definition" do
          UserlandAdapter.configure do |config|
            config.send("#{definable}=", "value")
          end
          expect(UserlandAdapter.configuration.send(definable)).to eq("value")
        end
      end

      it "conflates hostname and queue" do
        UserlandAdapter.configure do |config|
          config.hostname = "hostname"
        end
        expect(UserlandAdapter.configuration.queue).to eq("hostname")

        UserlandAdapter.configure do |config|
          config.queue = "queue"
        end
        expect(UserlandAdapter.configuration.hostname).to eq("queue")
      end
    end

    describe "transport mechanisms" do
      let(:mock_transport) { double }
      before :each do
        UserlandAdapter.configure{|c| c.transport = mock_transport }
      end

      describe "#target" do
        it "receives a uri and returns a uri combined with appropriate options" do
          UserlandAdapter.configure do |c|
            c.queue = 'partone'
            c.protocol = 'test'
          end
          expect(UserlandAdapter.new.target('/foo/bar')).to eq("test://partone/foo/bar")
        end
      end

      describe "#get" do
        it "transmits the message along the appropriate transport" do
          path = 'some_path'
          args = {body: {param: 'value'}}
          expect(mock_transport).to receive(:get).with(path, args)
          UserlandAdapter.get(path, args)
        end
      end

      describe "#post" do
        it "transmits the message along the appropriate transport" do
          path = 'some_path'
          args = {body: {param: 'value'}}
          expect(mock_transport).to receive(:post).with(path, args)
          UserlandAdapter.post(path, args)
        end
      end
    end
  end
end
