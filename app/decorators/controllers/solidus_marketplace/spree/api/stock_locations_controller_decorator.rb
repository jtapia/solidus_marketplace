# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module Api
      module StockLocationsControllerDecorator
        def self.prepended(base)
          base.class_eval do
            before_action :supplier_locations, only: [:index]
            before_action :supplier_transfers, only: [:index]
          end
        end

        private

        def supplier_locations
          params[:q] ||= {}
          params[:q][:supplier_id_eq] = spree_current_user.supplier_id
        end

        def supplier_transfers
          params[:q] ||= {}
          params[:q][:supplier_id_eq] = spree_current_user.supplier_id
        end

        ::Spree::Api::StockLocationsController.prepend self
      end
    end
  end
end
