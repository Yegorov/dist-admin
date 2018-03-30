# frozen_string_literal: true

# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # confirmation, reset password and unlock tokens in the database.
  # Devise will use the `secret_key_base` as its `secret_key`
  # by default. You can change it below and use your own secret key.
  # config.secret_key = '841a8a857f004dcbc5939ad58051effb5809f264b6c8f0acb557c6a09137558858f8024cd0f3dea93a570fbdc2496639640f611d1aa08545bf6e8f428e9636ba'

  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you use your own mailer class
  # with default "from" parameter.
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # Configure the class responsible to send e-mails.
  # config.mailer = 'Devise::Mailer'

  # Configure the parent class responsible to send e-mails.
  # config.parent_mailer = 'ActionMailer::Base'

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating a user. The default is
  # just :email. You can configure it to use [:username, :subdomain], so for
  # authenticating a user, both parameters are required. Remember that those
  # parameters are used only when authenticating and not when retrieving from
  # session. If you need permissions, you should implement that in a before filter.
  # You can also supply a hash where the value is a boolean determining whether
  # or not authentication should be aborted when the value is not present.
  # config.authentication_keys = [:email]

  # Configure parameters from the request object used for authentication. Each entry
  # given should be a request method and it will automatically be passed to the
  # find_for_authentication method and considered in your model lookup. For instance,
  # if you set :request_keys to [:subdomain], :subdomain will be used on authentication.
  # The same considerations mentioned for authentication_keys also apply to request_keys.
  # config.request_keys = []

  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when used
  # to authenticate or find a user. Default is :email.
  config.case_insensitive_keys = [:email]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used to authenticate or find a user. Default is :email.
  config.strip_whitespace_keys = [:email]

  # Tell if authentication through request.params is enabled. True by default.
  # It can be set to an array that will enable params authentication only for the
  # given strategies, for example, `config.params_authenticatable = [:database]` will
  # enable it only for database (email + password) authentication.
  # config.params_authenticatable = true

  # Tell if authentication through HTTP Auth is enabled. False by default.
  # It can be set to an array that will enable http authentication only for the
  # given strategies, for example, `config.http_authenticatable = [:database]` will
  # enable it only for database authentication. The supported strategies are:
  # :database      = Support basic authentication with authentication key + password
  # config.http_authenticatable = false

  # If 401 status code should be returned for AJAX requests. True by default.
  # config.http_authenticatable_on_xhr = true

  # The realm used in Http Basic Authentication. 'Application' by default.
  # config.http_authentication_realm = 'Application'

  # It will change confirmation, password recovery and other workflows
  # to behave the same regardless if the e-mail provided was right or wrong.
  # Does not affect registerable.
  # config.paranoid = true

  # By default Devise will store the user in session. You can skip storage for
  # particular strategies by setting this option.
  # Notice that if you are skipping storage for all authentication paths, you
  # may want to disable generating routes to Devise's sessions controller by
  # passing skip: :sessions to `devise_for` in your config/routes.rb
  config.skip_session_storage = [:http_auth]

  # By default, Devise cleans up the CSRF token on authentication to
  # avoid CSRF token fixation attacks. This means that, when using AJAX
  # requests for sign in and sign up, you need to get a new CSRF token
  # from the server. You can disable this option at your own risk.
  # config.clean_up_csrf_token_on_authentication = true

  # When false, Devise will not attempt to reload routes on eager load.
  # This can reduce the time taken to boot the app but if your application
  # requires the Devise mappings to be loaded during boot time the application
  # won't boot properly.
  # config.reload_routes = true

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 11. If
  # using other algorithms, it sets how many times you want the password to be hashed.
  #
  # Limiting the stretches to just one in testing will increase the performance of
  # your test suite dramatically. However, it is STRONGLY RECOMMENDED to not use
  # a value less than 10 in other environments. Note that, for bcrypt (the default
  # algorithm), the cost increases exponentially with the number of stretches (e.g.
  # a value of 20 is already extremely slow: approx. 60 seconds for 1 calculation).
  config.stretches = Rails.env.test? ? 1 : 11

  # Set up a pepper to generate the hashed password.
  # config.pepper = '59ba7999833fe6808ab8400897dc13ea0ac68991c5d61ac9c0dc7516ebab371bb21b226a0331983c57dcbd9e6b4246ea7a00b4044678a873428988dd6582a8ef'

  # Send a notification to the original email when the user's email is changed.
  # config.send_email_changed_notification = false

  # Send a notification email when the user's password is changed.
  # config.send_password_change_notification = false

  # ==> Configuration for :confirmable
  # A period that the user is allowed to access the website even without
  # confirming their account. For instance, if set to 2.days, the user will be
  # able to access the website for two days without confirming their account,
  # access will be blocked just in the third day. Default is 0.days, meaning
  # the user cannot access the website without confirming their account.
  # config.allow_unconfirmed_access_for = 2.days

  # A period that the user is allowed to confirm their account before their
  # token becomes invalid. For example, if set to 3.days, the user can confirm
  # their account within 3 days after the mail was sent, but on the fourth day
  # their account can't be confirmed with the token any more.
  # Default is nil, meaning there is no restriction on how long a user can take
  # before confirming their account.
  # config.confirm_within = 3.days

  # If true, requires any email changes to be confirmed (exactly the same way as
  # initial account confirmation) to be applied. Requires additional unconfirmed_email
  # db field (see migrations). Until confirmed, new email is stored in
  # unconfirmed_email column, and copied to email column on successful confirmation.
  config.reconfirmable = true

  # Defines which key will be used when confirming an account
  # config.confirmation_keys = [:email]

  # ==> Configuration for :rememberable
  # The time the user will be remembered without asking for credentials again.
  # config.remember_for = 2.weeks

  # Invalidates all the remember me tokens when the user signs out.
  config.expire_all_remember_me_on_sign_out = true

  # If true, extends the user's remember period when remembered via cookie.
  # config.extend_remember_period = false

  # Options to be passed to the created cookie. For instance, you can set
  # secure: true in order to force SSL only cookies.
  # config.rememberable_options = {}

  # ==> Configuration for :validatable
  # Range for password length.
  config.password_length = 6..128

  # Email regex used to validate email formats. It simply asserts that
  # one (and only one) @ exists in the given string. This is mainly
  # to give user feedback and not to assert the e-mail validity.
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :timeoutable
  # The time you want to timeout the user session without activity. After this
  # time the user will be asked for credentials again. Default is 30 minutes.
  # config.timeout_in = 30.minutes

  # ==> Configuration for :lockable
  # Defines which strategy will be used to lock an account.
  # :failed_attempts = Locks an account after a number of failed attempts to sign in.
  # :none            = No lock strategy. You should handle locking by yourself.
  # config.lock_strategy = :failed_attempts

  # Defines which key will be used when locking and unlocking an account
  # config.unlock_keys = [:email]

  # Defines which strategy will be used to unlock an account.
  # :email = Sends an unlock link to the user email
  # :time  = Re-enables login after a certain amount of time (see :unlock_in below)
  # :both  = Enables both strategies
  # :none  = No unlock strategy. You should handle unlocking by yourself.
  # config.unlock_strategy = :both

  # Number of authentication tries before locking an account if lock_strategy
  # is failed attempts.
  # config.maximum_attempts = 20

  # Time interval to unlock the account if :time is enabled as unlock_strategy.
  # config.unlock_in = 1.hour

  # Warn on the last attempt before the account is locked.
  # config.last_attempt_warning = true

  # ==> Configuration for :recoverable
  #
  # Defines which key will be used when recovering the password for an account
  # config.reset_password_keys = [:email]

  # Time interval you can reset your password with a reset password key.
  # Don't put a too small interval or your users won't have the time to
  # change their passwords.
  config.reset_password_within = 6.hours

  # When set to false, does not sign a user in automatically after their password is
  # reset. Defaults to true, so a user is signed in automatically after a reset.
  # config.sign_in_after_reset_password = true

  # ==> Configuration for :encryptable
  # Allow you to use another hashing or encryption algorithm besides bcrypt (default).
  # You can use :sha1, :sha512 or algorithms from others authentication tools as
  # :clearance_sha1, :authlogic_sha512 (then you should set stretches above to 20
  # for default behavior) and :restful_authentication_sha1 (then you should set
  # stretches to 10, and copy REST_AUTH_SITE_KEY to pepper).
  #
  # Require the `devise-encryptable` gem when using anything other than bcrypt
  # config.encryptor = :sha512

  # ==> Scopes configuration
  # Turn scoped views on. Before rendering "sessions/new", it will first check for
  # "users/sessions/new". It's turned off by default because it's slower if you
  # are using only default views.
  # config.scoped_views = false

  # Configure the default scope given to Warden. By default it's the first
  # devise role declared in your routes (usually :user).
  # config.default_scope = :user

  # Set this configuration to false if you want /users/sign_out to sign out
  # only the current scope. By default, Devise signs out all scopes.
  # config.sign_out_all_scopes = true

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational. Formats like
  # :html, should redirect to the sign in page when the user does not have
  # access, but formats like :xml or :json, should return 401.
  #
  # If you have any extra navigational formats, like :iphone or :mobile, you
  # should add them to the navigational formats lists.
  #
  # The "*/*" below is required to match Internet Explorer requests.
  # config.navigational_formats = ['*/*', :html]

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete

  # ==> OmniAuth
  # Add a new OmniAuth provider. Check the wiki for more information on setting
  # up on your models and hooks.
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'

  # ==> Warden configuration
  # If you want to use other strategies, that are not supported by Devise, or
  # change the failure app, you can configure them inside the config.warden block.
  #
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(scope: :user).unshift :some_external_strategy
  # end

  # ==> Mountable engine configurations
  # When using Devise inside an engine, let's call it `MyEngine`, and this engine
  # is mountable, there are some extra configurations to be taken into account.
  # The following options are available, assuming the engine is mounted as:
  #
  #     mount MyEngine, at: '/my_engine'
  #
  # The router that invoked `devise_for`, in the example above, would be:
  # config.router_name = :my_engine
  #
  # When using OmniAuth, Devise cannot automatically set OmniAuth path,
  # so you need to do it manually. For the users scope, it would be:
  # config.omniauth_path_prefix = '/my_engine/users/auth'
end

#
# Monkey path for this issue: https://github.com/plataformatec/devise/issues/4823
#


# https://github.com/plataformatec/devise/blob/master/lib/devise/failure_app.rb
require "action_controller/metal"

module Devise
  # Failure application that will be called every time :warden is thrown from
  # any strategy or hook. It is responsible for redirecting the user to the sign
  # in page based on current scope and mapping. If no scope is given, it
  # redirects to the default_url.
  class FailureApp < ActionController::Metal
    include ActionController::UrlFor
    include ActionController::Redirecting

    include Rails.application.routes.url_helpers
    include Rails.application.routes.mounted_helpers

    include Devise::Controllers::StoreLocation

    delegate :flash, to: :request

    def self.call(env)
      @respond ||= action(:respond)
      @respond.call(env)
    end

    # Try retrieving the URL options from the parent controller (usually
    # ApplicationController). Instance methods are not supported at the moment,
    # so only the class-level attribute is used.
    def self.default_url_options(*args)
      if defined?(Devise.parent_controller.constantize)
        Devise.parent_controller.constantize.try(:default_url_options) || {}
      else
        {}
      end
    end

    def respond
      if http_auth?
        http_auth
      elsif warden_options[:recall]
        recall
      else
        redirect
      end
    end

    def http_auth
      self.status = 401
      self.headers["WWW-Authenticate"] = %(Basic realm=#{Devise.http_authentication_realm.inspect}) if http_auth_header?
      self.content_type = request.format.to_s
      self.response_body = http_auth_body
    end

    def recall
      header_info = if relative_url_root?
        base_path = Pathname.new(relative_url_root)
        full_path = Pathname.new(attempted_path)

        { "SCRIPT_NAME" => relative_url_root,
          "PATH_INFO" => '/' + full_path.relative_path_from(base_path).to_s }
      else
        { "PATH_INFO" => attempted_path }
      end

      header_info.each do | var, value|
        if request.respond_to?(:set_header)
          request.set_header(var, value)
        else
          request.env[var]  = value
        end
      end

      flash.now[:alert] = i18n_message(:invalid) if is_flashing_format?
      # self.response = recall_app(warden_options[:recall]).call(env)
      self.response = recall_app(warden_options[:recall]).call(request.env)
    end

    def redirect
      store_location!
      if is_flashing_format?
        if flash[:timedout] && flash[:alert]
          flash.keep(:timedout)
          flash.keep(:alert)
        else
          flash[:alert] = i18n_message
        end
      end
      redirect_to redirect_url
    end

  protected

    def i18n_options(options)
      options
    end

    def i18n_message(default = nil)
      message = warden_message || default || :unauthenticated

      if message.is_a?(Symbol)
        options = {}
        options[:resource_name] = scope
        options[:scope] = "devise.failure"
        options[:default] = [message]
        auth_keys = scope_class.authentication_keys
        keys = (auth_keys.respond_to?(:keys) ? auth_keys.keys : auth_keys).map { |key| scope_class.human_attribute_name(key) }
        options[:authentication_keys] = keys.join(I18n.translate(:"support.array.words_connector"))
        options = i18n_options(options)
#binding.pry
I18n.locale = session[:locale] || I18n.locale
        I18n.t(:"#{scope}.#{message}", options)
      else
        message.to_s
      end
    end

    def redirect_url
      if warden_message == :timeout
        flash[:timedout] = true if is_flashing_format?

        path = if request.get?
          attempted_path
        else
          request.referrer
        end

        path || scope_url
      else
        scope_url
      end
    end

    def route(scope)
      :"new_#{scope}_session_url"
    end

    def scope_url
      opts  = {}

      # Initialize script_name with nil to prevent infinite loops in
      # authenticated mounted engines in rails 4.2 and 5.0
      opts[:script_name] = nil

      route = route(scope)

      opts[:format] = request_format unless skip_format?

      opts[:script_name] = relative_url_root if relative_url_root?

      router_name = Devise.mappings[scope].router_name || Devise.available_router_name
      context = send(router_name)

      if context.respond_to?(route)
        context.send(route, opts)
      elsif respond_to?(:root_url)
        root_url(opts)
      else
        "/"
      end
    end

    def skip_format?
      %w(html */*).include? request_format.to_s
    end

    # Choose whether we should respond in an HTTP authentication fashion,
    # including 401 and optional headers.
    #
    # This method allows the user to explicitly disable HTTP authentication
    # on AJAX requests in case they want to redirect on failures instead of
    # handling the errors on their own. This is useful in case your AJAX API
    # is the same as your public API and uses a format like JSON (so you
    # cannot mark JSON as a navigational format).
    def http_auth?
      if request.xhr?
        Devise.http_authenticatable_on_xhr
      else
        !(request_format && is_navigational_format?)
      end
    end

    # It doesn't make sense to send authenticate headers in AJAX requests
    # or if the user disabled them.
    def http_auth_header?
      scope_class.http_authenticatable && !request.xhr?
    end

    def http_auth_body
      return i18n_message unless request_format
      method = "to_#{request_format}"
      if method == "to_xml"
        { error: i18n_message }.to_xml(root: "errors")
      elsif {}.respond_to?(method)
        { error: i18n_message }.send(method)
      else
        i18n_message
      end
    end

    def recall_app(app)
      controller, action = app.split("#")
      controller_name  = ActiveSupport::Inflector.camelize(controller)
      controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
      controller_klass.action(action)
    end

    def warden
      request.respond_to?(:get_header) ? request.get_header("warden") : request.env["warden"]
    end

    def warden_options
      request.respond_to?(:get_header) ? request.get_header("warden.options") : request.env["warden.options"]
    end

    def warden_message
      @message ||= warden.message || warden_options[:message]
    end

    def scope
      @scope ||= warden_options[:scope] || Devise.default_scope
    end

    def scope_class
      @scope_class ||= Devise.mappings[scope].to
    end

    def attempted_path
      warden_options[:attempted_path]
    end

    # Stores requested URI to redirect the user after signing in. We can't use
    # the scoped session provided by warden here, since the user is not
    # authenticated yet, but we still need to store the URI based on scope, so
    # different scopes would never use the same URI to redirect.
    def store_location!
      store_location_for(scope, attempted_path) if request.get? && !http_auth?
    end

    def is_navigational_format?
      Devise.navigational_formats.include?(request_format)
    end

    # Check if flash messages should be emitted. Default is to do it on
    # navigational formats
    def is_flashing_format?
      is_navigational_format?
    end

    def request_format
      @request_format ||= request.format.try(:ref)
    end

    def relative_url_root
      @relative_url_root ||= begin
        config = Rails.application.config

        config.try(:relative_url_root) || config.action_controller.try(:relative_url_root)
      end
    end

    def relative_url_root?
      relative_url_root.present?
    end

    ActiveSupport.run_load_hooks(:devise_failure_app, self)
  end
end
