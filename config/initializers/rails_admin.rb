# frozen_string_literal: true

RailsAdmin.config do |config|
  config.main_app_name = ['Kursverteiler Web', 'Administration']
  config.show_gravatar = false

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
  # config.show_gravatar = true

  # Global RailsAdminImport options
  config.configure_with(:import) do |import_config|
    import_config.logging = false
    import_config.line_item_limit = 1000
    import_config.update_if_exists = true
    import_config.rollback_on_error = true
    import_config.header_converter = lambda do |header|
      header.parameterize.underscore if header.present?
    end
    import_config.csv_options = {}
  end

  config.actions do
    dashboard do                  # mandatory
      link_icon 'icon-list'
    end
    index                         # mandatory
    new
    export
    import
    # bulk_delete
    show
    edit
    # delete
    # show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end