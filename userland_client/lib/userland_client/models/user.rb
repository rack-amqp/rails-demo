module UserlandClient
  class User

    BASEPATH = '/users'

    include Virtus.model

    attribute :id, Integer
    attribute :login, String
    attribute :password, String
    attribute :created_at, Time
    attribute :updated_at, Time

    def to_json
      attributes.to_json
    end

    def save
      result = UserlandAdapter.post("#{BASEPATH}/#{id}", body: to_json)
      result
    end

    def self.login(login, password)
      response = UserlandAdapter.get("#{BASEPATH}/login", body: {login: login, password: password})
      if response.code == 200
        parsed_user_from_response(response)
      else
        nil
      end
    end

    private

    def self.parsed_user_from_response(response)
      User.new(
        id: response['id'],
        login: response['login'],
        password: response['password'],
        created_at: response['created_at'],
        updated_at: response['updated_at'],
      )
    end
  end
end
