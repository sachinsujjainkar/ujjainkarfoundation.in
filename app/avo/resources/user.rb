# प्रशासक-only -- see config/initializers/avo.rb's authenticate_with block
# for the real (controller-level) enforcement; visible_on_sidebar here is
# just the matching UX (don't show a menu item a non-admin would be
# bounced from). accounts are created by hand by an admin -- no public
# registration route exists anywhere in this app (config/routes.rb).
class Avo::Resources::User < Avo::BaseResource
  self.title = :name

  def visible_on_sidebar
    current_user&.can_manage_users_and_settings?
  end

  def fields
    field :id, as: :id
    field :name, as: :text, required: true, help: "उदा. रमेश पाटील"
    field :email_address, as: :text, required: true, help: "प्रवेशासाठी वापरला जाणारा ईमेल पत्ता"
    field :password, as: :password, required: -> { record.new_record? },
      help: "नवीन खात्यासाठी आवश्यक. विद्यमान खात्याचा पासवर्ड बदलण्यासाठी येथे नवीन पासवर्ड लिहा, अन्यथा रिकामे सोडा."
    field :password_confirmation, as: :password, hide_on: [ :index, :show ]
    field :role, as: :select, enum: ::User.roles, required: true,
      help: "प्रशासक: सर्वकाही. संपादक: प्रकाशित/अप्रकाशित करू शकतो. वार्ताहर: फक्त मसुदे."
    field :active, as: :boolean, help: "बंद केल्यास हे खाते प्रवेश करू शकणार नाही, पण जुन्या नोंदींवरील त्यांचे नाव कायम राहील."
    field :last_seen_at, as: :date_time, readonly: true
    field :sessions, as: :has_many
  end
end
