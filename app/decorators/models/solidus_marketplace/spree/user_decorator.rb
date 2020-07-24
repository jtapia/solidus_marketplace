# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.class_eval do
          belongs_to :supplier, class_name: 'Spree::Supplier', optional: true
          has_many :variants, through: :supplier
          after_create :check_for_api_token
        end
      end

      def supplier?
        supplier.present?
      end

      def supplier_admin?
        spree_roles.map(&:name).include?("supplier_admin")
      end

      def market_maker?
        has_admin_role?
      end

      def has_admin_role?
        spree_roles.map(&:name).include?("admin")
      end

      def check_for_api_token
        generate_spree_api_key! if supplier_admin? || supplier?
      end
    end
  end
end

Spree.user_class.prepend(SolidusMarketplace::Spree::UserDecorator)
