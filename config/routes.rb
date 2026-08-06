Rails.application.routes.draw do
  mount_avo
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Component gallery — development environment only, never routable in
  # production or test. See docs/02-design-system.md. Not locale-scoped: it's
  # a developer tool, not a public page.
  get "styleguide", to: "styleguide#index" if Rails.env.development?

  # Rails' exceptions_app (config/application.rb) dispatches unhandled
  # exceptions to these exact paths. Unprefixed on purpose -- the failure
  # that got us here may be the locale scoping itself, so ErrorsController
  # figures out the locale from the original request instead of a route
  # param. See docs/prompts/phase-03-layout-shell.md.
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # "/" is never served directly -- ambiguity here breaks caching, hreflang,
  # and sharing. Redirect to the visitor's best-fit locale (cookie, then
  # Accept-Language, default :mr) and let every real page live under
  # /mr/... or /en/.... See docs/04-routes.md and PreferredLocale.
  root to: redirect(status: 302) { |_params, request| "/#{PreferredLocale.for(request)}" }

  scope ":locale", locale: /mr|en/ do
    root to: "home#index", as: :locale_root
  end

  # Static/section pages, one scope per locale because the path segments
  # themselves are different translated words (not just a swapped :locale
  # prefix) -- see LocalizedPages and docs/04-routes.md.
  LocalizedPages::SEGMENTS.each do |name, segments|
    %i[mr en].each do |locale|
      scope "/#{locale}", locale: locale.to_s, as: locale do
        get segments.fetch(locale), to: LocalizedPages::TARGETS.fetch(name), as: name,
          defaults: { locale_page: name }
      end
    end
  end

  # Detail pages: index segment + "/:slug" -- see LocalizedPages::DETAIL_TARGETS.
  # Same locale_page default as the index routes above (ApplicationHelper's
  # alternate_locale_url reads it) -- distinguishing index vs. detail happens
  # there by checking for a :slug param, not by a different locale_page value.
  LocalizedPages::DETAIL_TARGETS.each do |name, target|
    segments = LocalizedPages::SEGMENTS.fetch(name)
    %i[mr en].each do |locale|
      scope "/#{locale}", locale: locale.to_s, as: locale do
        get "#{segments.fetch(locale)}/:slug", to: target, as: "#{name}_detail",
          defaults: { locale_page: name }
      end
    end
  end

  # Form submissions POST to the same path their GET page lives at
  # (contact_messages#new / volunteers#new above) -- no separate named
  # route needed, forms just target nav_path(:contact) / nav_path(:volunteer)
  # with method: :post.
  %i[mr en].each do |locale|
    scope "/#{locale}", locale: locale.to_s do
      post LocalizedPages::SEGMENTS.dig(:contact, locale), to: "contact_messages#create"
      post LocalizedPages::SEGMENTS.dig(:volunteer, locale), to: "volunteers#create"
    end
  end
end

if defined? ::Avo
  Avo::Engine.routes.draw do
    # Already covered by config.authenticate_with (config/initializers/avo.rb)
    # -- that runs as a before_action on every Avo controller, this one
    # included, not just Avo::ResourcesController.
    get "dashboard", to: "tools#dashboard", as: :dashboard
  end
end
