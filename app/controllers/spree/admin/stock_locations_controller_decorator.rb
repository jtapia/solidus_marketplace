Spree::Admin::StockLocationsController.class_eval do

  create.after :set_supplier

  def index
    @stock_locations = Spree::StockLocation.accessible_by(current_ability, :read)
                          .order('name ASC')
                          .ransack(params[:q])
                          .result
                          .page(params[:page])
                          .per(params[:per_page])
  end

  private

  def set_supplier
    if try_spree_current_user.supplier?
      @object.supplier = try_spree_current_user.supplier
      @object.save
    end
  end

end
