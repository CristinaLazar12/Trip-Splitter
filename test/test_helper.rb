# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # rulează testele în paralel (opțional)
  parallelize(workers: :number_of_processors) if respond_to?(:parallelize)
  # încarcă fixtures dacă folosești ActiveRecord și ai fișiere în test/fixtures
  fixtures :all if defined?(ActiveRecord)
end

# Helpers pentru teste de integrare (ex. Devise). Scoate linia dacă nu folosești Devise.
class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers if defined?(Devise)
end

module SignInHelper
  def sign_in_as(user)
    post session_path(email_address: user.email_address, password: "password")
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end