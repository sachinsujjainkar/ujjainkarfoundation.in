# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"

# Avo custom JS entrypoint -- app/javascript/avo.custom.js
pin "avo.custom"
pin "html-to-image" # @1.11.13
pin "https://cdn.jsdelivr.net/npm/html-to-image@1.11.13/es/apply-style", to: "https:----cdn.jsdelivr.net--npm--html-to-image@1.11.13--es--apply-style.js" # @1.11.13
pin "https://cdn.jsdelivr.net/npm/html-to-image@1.11.13/es/clone-node", to: "https:----cdn.jsdelivr.net--npm--html-to-image@1.11.13--es--clone-node.js" # @1.11.13
pin "https://cdn.jsdelivr.net/npm/html-to-image@1.11.13/es/clone-pseudos", to: "https:----cdn.jsdelivr.net--npm--html-to-image@1.11.13--es--clone-pseudos.js" # @1.11.13
pin "https://cdn.jsdelivr.net/npm/html-to-image@1.11.13/es/dataurl", to: "https:----cdn.jsdelivr.net--npm--html-to-image@1.11.13--es--dataurl.js" # @1.11.13
pin "https://cdn.jsdelivr.net/npm/html-to-image@1.11.13/es/embed-images", to: "https:----cdn.jsdelivr.net--npm--html-to-image@1.11.13--es--embed-images.js" # @1.11.13
pin "https://cdn.jsdelivr.net/npm/html-to-image@1.11.13/es/embed-resources", to: "https:----cdn.jsdelivr.net--npm--html-to-image@1.11.13--es--embed-resources.js" # @1.11.13
pin "https://cdn.jsdelivr.net/npm/html-to-image@1.11.13/es/embed-webfonts", to: "https:----cdn.jsdelivr.net--npm--html-to-image@1.11.13--es--embed-webfonts.js" # @1.11.13
pin "https://cdn.jsdelivr.net/npm/html-to-image@1.11.13/es/mimes", to: "https:----cdn.jsdelivr.net--npm--html-to-image@1.11.13--es--mimes.js" # @1.11.13
pin "https://cdn.jsdelivr.net/npm/html-to-image@1.11.13/es/util", to: "https:----cdn.jsdelivr.net--npm--html-to-image@1.11.13--es--util.js" # @1.11.13
