# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# So the problem was that I forgot to run rake assets:precompile. The solution for development.
# SOLUTION
# Add <%= javascript_include_tag 'ratyrate.js', "data-turbolinks-track" => false %> to the head (seems to run faster) or body tag in your view.
# Also add Rails.application.config.assets.precompile += %w( ratyrate.js )
# to config/initializers/assets.rb.
# run rake assets:precompile
