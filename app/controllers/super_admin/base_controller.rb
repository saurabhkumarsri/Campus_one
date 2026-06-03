module SuperAdmin
  class BaseController < ApplicationController
    before_action :require_super_admin
  end
end
