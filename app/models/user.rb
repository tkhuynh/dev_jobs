class User < ActiveRecord::Base
	has_secure_password
	has_many :jobs

	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }
	validates	:password, length: {minimum: 6}

end
