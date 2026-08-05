ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # assert_enqueued_with, assert_enqueued_jobs, etc. -- used by
    # ImageUploadSafety-backed models (Person#photo) to confirm background
    # work is scheduled without actually running it (no libvips in this
    # environment; see app/models/concerns/photoable.rb).
    include ActiveJob::TestHelper

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # I18n.locale is a global set by ApplicationController#set_locale on
    # every request -- without this, a test that hits /en leaves the
    # locale changed for whatever test runs next in the same worker.
    teardown do
      I18n.locale = I18n.default_locale
    end

    # Add more helper methods to be used by all tests here...
  end
end
