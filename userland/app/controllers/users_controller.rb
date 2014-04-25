class Time
  def to_msgpack(*args)
    self.to_i.to_msgpack(*args)
  end
end
class UsersController < ApplicationController
  respond_to :json, :msgpack, :protobuf, :marshall

  def index
    respond_to do |fmt|
      fmt.json do
        render json: users
      end
      fmt.msgpack do
        send_data MessagePack.pack(users.as_json)
      end
      fmt.protobuf do
        d = Userland::Users.new
        d.user = users.map(&:to_pb)
        send_data d.serialize_to_string
      end
    end
  end

  def create
    User.create user_params
    head :ok
  end

  def show
    respond_with User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update_attributes user_params
    respond_with user
  end

  def login
    @user = User.where(login: params[:login], password: params[:password]).first
    if @user
      render json: @user.to_json, status: 200
    else
      render nothing: true, status: 401
    end
  end

  private

  def user_params
    params.require(:login, :password)
  end

  def users
    #Rails.cache.fetch('us'){ [User.all, User.all, User.all, User.all] }
    [User.all, User.all, User.all, User.all].flatten
  end
end
