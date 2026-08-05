Rails.application.routes.draw do
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

  # "/" is never served directly -- ambiguity here breaks caching, hreflang,
  # and sharing. Redirect to the visitor's best-fit locale (cookie, then
  # Accept-Language, default :mr) and let every real page live under
  # /mr/... or /en/.... See docs/04-routes.md and PreferredLocale.
  root to: redirect(status: 302) { |_params, request| "/#{PreferredLocale.for(request)}" }

  scope ":locale", locale: /mr|en/ do
    root to: "home#index", as: :locale_root
  end
end
