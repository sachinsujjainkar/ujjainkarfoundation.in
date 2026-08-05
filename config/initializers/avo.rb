# For more information regarding these settings check out our docs https://docs.avohq.io
# The values disaplayed here are the default ones. Uncomment and change them to fit your needs.
Avo.configure do |config|
  ## == Routing ==
  config.root_path = "/admin"
  # used only when you have custom `map` configuration in your config.ru
  # config.prefix_path = "/internal"

  # Without this, /admin shows Avo's own "Welcome to Avo" onboarding panel
  # in development (Avo::HomeController#index: unconditional in dev unless
  # home_path is set) -- confirmed by hitting /admin directly and reading
  # the actual response. app/views/avo/tools/dashboard.html.erb is the
  # custom-tool-based dashboard (see app/controllers/avo/tools_controller.rb
  # for why it's a Tool and not Avo's Dashboard DSL).
  config.home_path = -> { "#{Avo.configuration.root_path}/dashboard" }

  ## == Licensing ==
  # config.license_key = ENV['AVO_LICENSE_KEY']

  ## == Set the context ==
  config.set_context do
    # Return a context object that gets evaluated within Avo::ApplicationController
  end

  ## == Authentication ==
  # Ties Avo into the same Session/Current mechanism as the rest of the
  # staff auth (app/controllers/concerns/authentication.rb) rather than a
  # separate login system. Avo's own controllers aren't ApplicationController
  # subclasses that include that concern, so this block does the equivalent
  # by hand: resume the session from the signed cookie, redirect to the
  # real login page if there isn't one. Deactivated accounts are also
  # refused here, not just at login -- someone deactivated mid-session
  # shouldn't keep admin access until their cookie expires.
  #
  # Also carries this app's ENTIRE per-role access control, not just login --
  # see "Authorization" below for why. block runs instance_exec'd in an Avo
  # controller, so params/request/redirect_to/cookies are all available.
  config.current_user_method do
    Current.session&.user
  end
  config.authenticate_with do
    Current.session ||= Session.find_by(id: cookies.signed[:session_id])
    user = Current.session&.user

    # Avo gives standard CRUD actions their own literal per-resource routes
    # (/admin/resources/users, /admin/resources/site_settings, ...) rather
    # than a shared /:resource_name segment -- params[:resource_name] is
    # only populated on the handful of generic shared endpoints (actions,
    # associations, search), NOT on index/show/create/update/destroy.
    # Confirmed by actually running this check against a live request and
    # watching it silently never match -- matching on the path itself is
    # the reliable way to identify which resource is being hit here.
    admin_only_resource = request.path.match?(%r{\A/admin/resources/(users|site_settings)(/|\z)})

    if user.nil? || !user.active?
      redirect_to "/session/new"
    elsif admin_only_resource && !user.can_manage_users_and_settings?
      # प्रशासक-only resources -- docs/00-project-brief.md's role matrix,
      # "Users & settings" row. Checked here, not just hidden from the
      # sidebar (Avo::Resources::User/SiteSetting also override
      # visible_on_sidebar for that), because a hidden menu item is a UX
      # nicety, not access control -- someone could still type the URL.
      redirect_to "/admin", alert: I18n.t("auth.not_authorized")
    elsif request.delete? && !user.can_delete?
      # "Delete: admin only" applies across every resource, not just
      # users/settings -- prompts/phase-07-admin-auth.md's role table.
      redirect_to "/admin", alert: I18n.t("auth.not_authorized")
    end
  end

  ## == Authorization ==
  # Avo's own per-resource authorization system (index?/create?/destroy?
  # policy methods, resource.authorization) is an Avo PRO feature --
  # confirmed by reading the gem source (lib/avo/configuration.rb:
  # authorization_enabled? requires the avo-pro plugin) -- with the
  # community edition installed here it's a permanent no-op regardless of
  # what's configured below. Real enforcement lives in authenticate_with
  # above instead, using plain User#can_*? methods -- which is also more in
  # the spirit of "not a permissions gem" than adding Pundit just to
  # unlock a feature this app's tier doesn't have.
  config.authorization_client = nil

  ## == Localization ==
  config.locale = "mr"

  ## == Resource options ==
  # config.resource_row_controls_config = {
  #   placement: :right,
  #   float: false,
  #   show_on_hover: false
  # }.freeze
  # config.model_resource_mapping = {}
  # config.default_view_type = :table
  # config.per_page = 24
  # config.per_page_steps = [12, 24, 48, 72]
  # config.via_per_page = 8
  # config.id_links_to_resource = false
  # config.pagination = -> do
  #   {
  #     type: :default,
  #     size: 9, # `[1, 2, 2, 1]` for pagy < 9.0
  #   }
  # end

  ## == Response messages dismiss time ==
  # config.alert_dismiss_time = 5000


  ## == Number of search results to display ==
  # config.search_results_count = 8

  ## == Associations lookup list limit ==
  # config.associations_lookup_list_limit = 1000

  ## == Cache options ==
  ## Provide a lambda to customize the cache store used by Avo.
  ## We compute the cache store by default, this is NOT the default, just an example.
  # config.cache_store = -> {
  #   ActiveSupport::Cache.lookup_store(:solid_cache_store)
  # }
  # config.cache_resources_on_index_view = true

  ## == Turbo options ==
  # config.turbo = -> do
  #   {
  #     instant_click: true
  #   }
  # end

  ## == Logger ==
  # config.logger = -> {
  #   file_logger = ActiveSupport::Logger.new(Rails.root.join("log", "avo.log"))
  #
  #   file_logger.datetime_format = "%Y-%m-%d %H:%M:%S"
  #   file_logger.formatter = proc do |severity, time, progname, msg|
  #     "[Avo] #{time}: #{msg}\n".tap do |i|
  #       puts i
  #     end
  #   end
  #
  #   file_logger
  # }

  ## == Customization ==
  config.click_row_to_view_record = true
  # config.app_name = 'Avocadelicious'
  # config.timezone = 'UTC'
  # config.currency = 'USD'
  # config.hide_layout_when_printing = false
  # config.full_width_container = false
  # config.full_width_index_view = false
  # config.search_debounce = 300
  # config.view_component_path = "app/components"
  # config.display_license_request_timeout_error = true
  # config.disabled_features = []
  # config.buttons_on_form_footers = true
  # config.field_wrapper_layout = true
  # config.resource_parent_controller = "Avo::ResourcesController"
  # config.first_sorting_option = :desc # :desc or :asc
  # config.exclude_from_status = []
  # config.model_generator_hook = true

  ## == Branding ==
  # config.branding = {
  #   colors: {
  #     background: "248 246 242",
  #     100 => "#CEE7F8",
  #     400 => "#399EE5",
  #     500 => "#0886DE",
  #     600 => "#066BB2",
  #   },
  #   chart_colors: ["#0B8AE2", "#34C683", "#2AB1EE", "#34C6A8"],
  #   logo: "/avo-assets/logo.png",
  #   logomark: "/avo-assets/logomark.png",
  #   placeholder: "/avo-assets/placeholder.svg",
  #   favicon: "/avo-assets/favicon.ico"
  # }

  ## == Breadcrumbs ==
  # config.display_breadcrumbs = true
  # config.set_initial_breadcrumbs do
  #   add_breadcrumb "Home", '/avo'
  # end

  ## == Menus ==
  # config.main_menu = -> {
  #   section "Dashboards", icon: "avo/dashboards" do
  #     all_dashboards
  #   end

  #   section "Resources", icon: "avo/resources" do
  #     all_resources
  #   end

  #   section "Tools", icon: "avo/tools" do
  #     all_tools
  #   end
  # }
  # config.profile_menu = -> {
  #   link "Profile", path: "/avo/profile", icon: "heroicons/outline/user-circle"
  # }
end
