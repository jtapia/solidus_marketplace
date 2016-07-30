module SpreeDropShip
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_drop_ship'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_drop_ship.custom_splitters', after: 'spree.register.stock_splitters' do |app|
      app.config.spree.stock_splitters << Spree::Stock::Splitter::DropShip
    end

    initializer "spree_drop_ship.preferences", before: :load_config_initializers  do |app|
      SpreeDropShip::Config = Spree::DropShipConfiguration.new
    end

    initializer "spree_drop_ship.menu", before: :load_config_initializers  do |app|
      Spree::Backend::Config.configure do |config|
        config.menu_items << Spree::BackendConfiguration::MenuItem.new(
          [:stock_locations],
          'globe',
          condition: -> { can?(:index, Spree::StockLocation) },
        )

        config.menu_items << Spree::BackendConfiguration::MenuItem.new(
          [:suppliers],
          'home',
          condition: -> { can?(:index, Spree::Supplier) },
        )

        config.menu_items << Spree::BackendConfiguration::MenuItem.new(
          [:shipments],
          'plane',
          condition: -> { can?(:index, Spree::Shipment) },
        )
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Spree::Ability.register_ability(Spree::SupplierAbility)
    end

    config.to_prepare &method(:activate).to_proc
  end
end
