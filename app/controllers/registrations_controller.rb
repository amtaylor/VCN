class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, :only => [:new, :create]
  skip_before_filter :require_user, :only => [:new, :create]
end