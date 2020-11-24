# frozen_string_literal: true

module RailsAdmin
  module Config
    module Actions
      # Distributes Students to chosen courses. This only works with courses and students atm.
      class Distribute < RailsAdmin::Config::Actions::Base
        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-share-alt'
        end

        register_instance_option :controller do
          proc do

          end
        end

      end
    end
  end
end
