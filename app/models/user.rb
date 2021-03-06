class User < ApplicationRecord
  has_secure_password
  has_many :documents, dependent: :destroy
  has_one :account, dependent: :destroy
  accepts_nested_attributes_for :account, allow_destroy: true

  scope :by_status, -> status { joins(:account).where("accounts.status = ?", status) }
  scope :by_date, -> created_at { where(created_at: Date.parse(created_at)) }
  scope :by_period, -> started_at, ended_at { where(created_at: Date.parse(started_at)..Date.parse(ended_at)) }
  scope :by_days, -> days { where(created_at: Date.today..days.to_i.days.from_now) }

  validates_presence_of :email, :password_digest
  validates_uniqueness_of :email

  enum status: {
    activo: "activo",
    inactivo: "inactivo"
  }

  def full_name
    "#{account.name.capitalize} #{account.last_name.capitalize}"
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    self.password_confirmation = password
    save!
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end
end
