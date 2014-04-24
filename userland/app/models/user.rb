# == Schema Information
# Schema version: 20131207163108
#
# Table name: users
#
#  id         :integer          not null, primary key
#  login      :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require_relative '../../userland.pb'
class User < ActiveRecord::Base

  def self.login(login, password)
    User.where(login: login, password: password).first
  end

  def to_pb
    pb = Userland::User.new
    attributes.each do |k,v|
      if k =~ /_at/
        pb.send("#{k}=", v.to_i)
      else
        pb.send("#{k}=",v)
      end
    end
    pb
  end
end
