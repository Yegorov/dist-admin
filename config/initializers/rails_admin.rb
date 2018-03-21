RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  #config.authorize_with :pundit
  # https://github.com/sferik/rails_admin/wiki/Authorization
  config.authorize_with do
    unless current_user.admin?
      flash[:alert] = "Sorry, but You are not authorized to perform this action."
      redirect_to(request.referrer || main_app.root_path)
    end
  end

  #config.parent_controller = 'ApplicationController' # see https://github.com/sferik/rails_admin/blob/c903d2e1702c6652eaf33ded8fa0892a4f434af1/CHANGELOG.md#changed
  # https://github.com/sferik/rails_admin/wiki/CanCanCan#handle-unauthorized-access

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  # gem "rails_admin_pundit", :github => "sudosu/rails_admin_pundit"
  # more see in https://github.com/sudosu/rails_admin_pundit/issues/12
  # or manualy https://github.com/sferik/rails_admin/wiki/Authorization
  module RailsAdmin
    module Extensions
      module Pundit
        class AuthorizationAdapter
          def authorize(action, abstract_model = nil, model_object = nil)
            record = model_object || abstract_model && abstract_model.model
            if action && !policy(record).send(*action_for_pundit(action))
              raise ::Pundit::NotAuthorizedError.new("not allowed to #{action} this #{record}")
            end
            @controller.instance_variable_set(:@_pundit_policy_authorized, true)
          end

          def authorized?(action, abstract_model = nil, model_object = nil)
            record = model_object || abstract_model && abstract_model.model
            policy(record).send(*action_for_pundit(action)) if action
          end

          def action_for_pundit(action)
            [:rails_admin?, action]
          end
        end
      end
    end
  end
end
