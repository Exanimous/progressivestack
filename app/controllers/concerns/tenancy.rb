module Tenancy
  extend ActiveSupport::Concern

  # /* Handle application tenancy logic here */
  # multitenancy: http://blog.elbowroomstudios.com/zero-to-multitenant-in-15-minutes-a-rails-walkthrough/
  # role based authentication: https://blog.chaps.io/2015/11/13/role-based-authorization-in-rails.html
  # http://www.blaketidwell.com/2015/08/21/emulate-default-scope-with-around-filter-and-scoping.html

  included do
    helper_method :current_tenant
  end

  private

  # primary access control point:
  # returns all tenant permissions for user
  # currently not used as user will only have one tenant with current implementation
  def current_tenant_permissions
    if current_or_guest_user
      current_or_guest_user.tenant_ids
    else
      nil
    end
  end

  # returns primary (base) tenant permission for user
  def primary_tenant_permission
    if current_or_guest_user
      current_or_guest_user.tenant_ids.first
    else
      nil
    end
  end
end