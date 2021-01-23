class AuthorizationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_action :authenticate_user!

  def index
  end

  def create
    current_user.oauth_authorizations.find_or_initialize_by(provider: auth_hash.provider) do |auth|
      auth.uid = auth_hash.uid
      auth.credentials = auth_hash.credentials.to_h
      auth.extra = auth_hash.extra.to_h
      auth.info = auth_hash.info.to_h
    end.save!

    redirect_to (request.env['omniauth.origin'] || panel_path), notice: 'Authorized'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
