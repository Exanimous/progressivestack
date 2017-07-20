class AccessControl
  # scope all quota by tenancy

  # http://davidlesches.com/blog/multitenancy-in-rails

  # A user will normally have a single tenancy model - that should be created with User creation via callbacks
  # User models are linked to their Tenant via UserTenants
  # A User asserts ownership of created models via their Tenant model
  # The tenant model is connected to Quotum and other user-generated objects objects via association keys linked to UserTenants
  # The Tenant-UserTenant system can allow shared control and permission based access to user-generated objects (not yet implemented)

  # instantiating with force_empty will ensure empty associations are returned

  def initialize(user, force_empty = false)
    @user = user
    @force_empty = force_empty
  end

  # force return of blank (empty) ActiveRecord result
  def quota_set_to_empty(force_empty)
    @force_empty = force_empty
    return self
  end

  # returns all quotum models that user can view (read only)
  def quota_viewable
    return Quotum.none if @force_empty
    if @user.present?
      if @user.tenant_ids
        Quotum.where(tenant_id: @user.tenant_ids).or(Quotum.where(tenant_id: nil)).and()
      else
        Quotum.where(tenant_id: nil)
      end
    else
      Quotum.where(tenant_id: nil)
    end
  end

  # returns only read-only quota
  def quota_view_only
    return Quotum.none if @force_empty
    if @user.present?
      if @user.tenant_ids
        Quotum.where(tenant_id: !@user.tenant_ids, tenant_id: nil)
      else
        Quotum.where(tenant_id: nil)
      end
    else
      Quotum.where(tenant_id: nil)
    end
  end

  # returns all quotum models that user has control over
  def quota_controllable
    return Quotum.none if @force_empty
    if @user.present?
      if @user.tenant_ids
        Quotum.where(tenant_id: @user.tenant_ids).all
      else
        Quotum.none.all
      end
    else
      Quotum.none.all
    end
  end

  private

end