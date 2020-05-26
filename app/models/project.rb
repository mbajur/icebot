class Project < ApplicationRecord
  belongs_to :user
  has_many :metrics

  before_save :ensure_token

  private

  def ensure_token
    self.token ||= SecureRandom.uuid
  end
end
