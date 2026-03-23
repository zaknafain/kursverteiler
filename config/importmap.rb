# Pin npm packages using the importmap-rails tasks (e.g., `bin/rails importmap:json`)

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.es2017-esm.js", preload: true
pin "@rails/ujs", to: "rails-ujs.js", preload: true
pin "@rails/activestorage", to: "activestorage.esm.js", preload: true
