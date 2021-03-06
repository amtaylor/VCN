class SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, :only => [:new, :create]
  skip_before_filter :require_user, :only => [:new, :create]
end