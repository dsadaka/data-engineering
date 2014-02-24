class Item < ActiveRecord::Base
  belongs_to :merchant
  has_many :purchases

  def self.fetch_or_create(description = nil, price = nil, merchant_id = nil)
    item = where(["description = ? COLLATE NOCASE", description]).first
    exists = !item.nil?
    unless item
      item = create(description: description, price: price, merchant_id: merchant_id)
    end

    return item, exists
  end

end
