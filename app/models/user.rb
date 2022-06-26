class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  has_many :oauth_providers

  def self.from_omniauth(auth)
    if auth.provider == "line"
      oauth_provider = OauthProvider.find_or_create_by(uid: auth.uid)
      oauth_provider.name = auth.info.name
      oauth_provider.user ||= User.create
      oauth_provider.save
      return oauth_provider.user
    end
  end

  def email_required?
    false
  end

  def password_required?
    false
  end
end