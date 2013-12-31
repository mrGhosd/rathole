class BaseAuthorizer < ApplicationAuthorizer
	def self.readable_by?(user)
		user.present?
	end

	def self.updatable_by?(user)
		user.present?
	end

	def self.creatable_by?(user)
		user.present?
	end

	def self.deletable_by?(user)
		user.present?
	end

	def readable_by?(user)
		check_owner user, resource
	end

	def updatable_by?(user)
		check_owner user, resource
	end

	def deletable_by?(user)
		check_owner user, resource
	end
end