require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "about page renders the founder_pending fallback when no founder Person exists" do
    get "/mr/aamchyavishayi"
    assert_response :success
    assert_match "संस्थापकांची माहिती लवकरच येथे प्रसिद्ध केली जाईल.", response.body
  end

  test "about page renders the real founder bio once a matching Person exists" do
    founder = Person.new(name_mr: PagesController::FOUNDER_NAME_MR)
    founder.honorific_mr = "डॉ."
    founder.bio_mr = "चाचणी चरित्र मजकूर."
    founder.save!

    get "/mr/aamchyavishayi"
    assert_response :success
    assert_match "डॉ. #{PagesController::FOUNDER_NAME_MR}", response.body
    assert_match "चाचणी चरित्र मजकूर.", response.body
    assert_no_match "संस्थापकांची माहिती लवकरच येथे प्रसिद्ध केली जाईल.", response.body
  end
end
