# frozen_string_literal: true

require 'spec_helper'

describe Spree::Payment do
  it { is_expected.to respond_to(:payable) }
end
