class Order

  attr_accessor :pair
  attr_accessor :state

  def initialize(pair = 'XBTZAR', state = nil)
    @pair = pair
    @state = state
  end

  def get_orders
    BitX.list_orders(pair)
  end

  def get_pending_orders
    BitX.list_orders(pair, state: 'PENDING', pair: pair)
  end

  def pending_display
    pending = get_pending_orders

  end
end