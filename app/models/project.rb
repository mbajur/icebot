# typed: false
class Project < ApplicationRecord
  belongs_to :user
  has_many :metrics

  before_save :ensure_token

  enum provider: { github: 0 }

  private

  def ensure_token
    self.token ||= SecureRandom.uuid
  end
end
