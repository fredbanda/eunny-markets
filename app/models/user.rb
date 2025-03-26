class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 8 }

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  before_validation :strip_extraneous_spaces

  private

  def strip_extraneous_spaces
    self.name = self.name&.strip
    self.email = self.email&.strip
  end
end
