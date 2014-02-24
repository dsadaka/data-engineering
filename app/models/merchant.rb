class Merchant < ActiveRecord::Base
  has_many :items, :foreign_key => :merchant_id

  def self.fetch_or_create(name = nil, address = nil)
    merchant = where(["name = ? COLLATE NOCASE", name]).first
    exists = !merchant.nil?
    unless exists
      merchant = create(name: name, address: address)
    end

    return merchant, exists
  end
end
