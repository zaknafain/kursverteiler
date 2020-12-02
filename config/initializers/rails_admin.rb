# frozen_string_literal: true

RailsAdmin.config do |config|
  config.parent_controller = '::ApplicationController'

  config.main_app_name = ['Kursverteiler Web', 'Administration']

  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  config.show_gravatar = false

  # Global RailsAdminImport options
  config.configure_with(:import) do |import_config|
    IMPORT_HEADER_MAPPING = {
      beschreibung:          :description,
      e_mail:                :email,
      garantierter_platz:    :guaranteed,
      klassenname:           :grade,
      kursbeschreibung:      :description,
      kurstitel:             :title,
      kurswahl:              :poll,
      lehrkraft:             :teacher_name,
      maximale_schulerzahl:  :maximum,
      minimale_schulerzahl:  :minimum,
      mogliche_schwerpunkte: :focus_areas,
      mogliche_varianten:    :variants,
      nachname:              :last_name,
      name_der_lehrkraft:    :teacher_name,
      schwerpunkte:          :focus_areas,
      titel:                 :title,
      titel_kurswahl:        :poll,
      titel_vorheriger_kurs: :parent_course,
      varianten:             :variants,
      vorname:               :first_name,
    }

    import_config.logging = false
    import_config.line_item_limit = 1000
    import_config.update_if_exists = true
    import_config.rollback_on_error = false
    import_config.header_converter = lambda do |header|
      if header.present?
        trans_header = header.parameterize.underscore.to_sym

        IMPORT_HEADER_MAPPING[trans_header] || trans_header
      end
    end
    import_config.csv_options = { col_sep: ';' }
  end

  config.included_models = %w[Admin Grade Student Poll Course]
  config.label_methods = [:to_pretty_value]

  RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::Distribute)

  config.actions do
    dashboard do                  # mandatory
      link_icon 'icon-list'
    end
    index                         # mandatory
    new
    export
    import do
      except %w[Admin Poll]
    end
    # bulk_delete
    show
    edit
    delete do
      only %w[Student]
    end
    distribute do
      only %w[Poll]
    end
    # show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.navigation_static_links = {
    'English' => '?locale=en',
    'Deutsch' => '?locale=de',
  }
end
