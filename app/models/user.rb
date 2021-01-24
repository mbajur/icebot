# typed: strict
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise_modules = [:database_authenticatable,
                    :recoverable,
                    :rememberable,
                    :validatable]

  devise_modules << :registerable if Figaro.env.sign_up_opened == 'true'
  devise *devise_modules

  has_many :oauth_authorizations, dependent: :destroy
  has_many :projects, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
end
