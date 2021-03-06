# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  login                  :string           not null
#  role                   :integer          default("user"), not null
#  banned                 :boolean          default(FALSE), not null
#  deleted                :boolean          default(FALSE), not null
#  public                 :boolean          default(FALSE), not null
#  document_sequence      :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_login                 (login) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  enum role: { admin: 1, user: 2 }
  #devise :timeoutable, :timeout_in => 1.minutes
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :documents, foreign_key: "owner_id", dependent: :delete_all
  has_many :tasks, foreign_key: "owner_id", dependent: :delete_all
  has_many :scripts, foreign_key: "owner_id", dependent: :delete_all

  validates :name, :login, :email, presence: true
  validates :login, :email, uniqueness: true
  validates :login, length: { minimum: 5, maximum: 50 },
                    format: { with: /\A[a-z][a-z0-9]+\z/ }

  scope :existent, -> { where(deleted: false) }
  scope :available, -> { existent.where(banned: false) }

  def active_for_authentication?
    super && !self.deleted?
  end

  def admin?
    self.role == "admin"
  end

  def soft_delete
    self.deleted = true
    save
  end

  def to_param
    self.login
  end
end
