# frozen_string_literal: true

class User < ApplicationRecord

  has_many :boxes
  has_many :rooms #, :include => [:boxes] 
  has_many :todos

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         # :omniauthable, omniauth_providers: [:github]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  # return the number of days remaining util the move date
  def moving_in
    move_date ? (move_date - Date.today).to_i : 0
  end

end
