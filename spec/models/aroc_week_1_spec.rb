require 'rails_helper'
require 'byebug'

describe 'ActiveRecord Obstacle Course, Week 1' do

# Looking for your test setup data?
# It's currently inside /spec/rails_helper.rb
# Not a very elegant solution, but works for this iteration.

# Here are the docs associated with ActiveRecord queries: http://guides.rubyonrails.org/active_record_querying.html

# ----------------------

## How to complete these exercises: 
# Currently, these tests are passing becasue we're using Ruby to do it. Re-write the Ruby solutions using ActiveRecord. 
# You can comment out the Ruby example after your AR is working. 

  it '1. finds orders by amount' do
    # ----------------------- Using Ruby -------------------------
    # @real=0.0023669999791309237
    # orders_of_500 = Order.all.select { |order| order.amount == 500 }
    # orders_of_200 = Order.all.select { |order| order.amount == 200 }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # @real=0.0002500000409781933 ( 10x faster )
    orders_of_500 = Order.where(amount: 500)
    orders_of_200 = Order.where(amount: 200)
    # ------------------------------------------------------------

    # Expectation
    expect(orders_of_500.count).to eq(1)
    expect(orders_of_200.count).to eq(1)
  end

  it '2. finds order id of smallest order' do
    # ----------------------- Using Raw SQL ----------------------
    # @real=0.001062000053934753
    # order_id = ActiveRecord::Base.connection.execute('SELECT id FROM orders ORDER BY amount ASC LIMIT 1').first['id']
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # @real=0.001032999949529767
    order_id = Order.order(:amount).limit(1).take.id
    # ------------------------------------------------------------

    # Expectation
    expect(order_id).to eq(@order_1.id)
  end

  it '3. finds order id of largest order' do
    # ----------------------- Using Raw SQL ----------------------
    # @real=0.0011199999134987593
    # order_id = ActiveRecord::Base.connection.execute('SELECT id FROM orders ORDER BY amount DESC LIMIT 1').first['id']
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # @real=0.0014700000174343586
    order_id = Order.order(amount: :desc).limit(1).take.id
    # ------------------------------------------------------------

    # Expectation
    expect(order_id).to eq(@order_15.id)
  end

  it '4. finds orders of multiple amounts' do
    # ----------------------- Using Ruby -------------------------
    # @real=0.0022820000303909183
    # orders_of_500_and_700 = Order.all.select do |order|
    #   order.amount == 500 || order.amount == 700
    # end
    #
    # orders_of_700_and_1000 = Order.all.select do |order|
    #   order.amount == 700 || order.amount == 1000
    # end
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # @real=0.0008270000107586384
    orders_of_500_and_700 = Order.where(amount: 500).or(Order.where(amount: 700))
    orders_of_700_and_1000 = Order.where(amount: 700).or(Order.where(amount: 1000))
    # ------------------------------------------------------------

    # Expectation
    expect(orders_of_500_and_700.count).to eq(2)
    expect(orders_of_700_and_1000.count).to eq(2)
  end

  it '5. finds multiple items by id' do
    ids_to_find = [@item_1.id, @item_2.id, @item_4.id]
    expected_objects = [@item_1, @item_4, @item_2]

    # ----------------------- Using Ruby -------------------------
    # @real=0.0017600000137463212
    # items = Item.all.select { |item| ids_to_find.include?(item.id) }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # @real=0.001661999966017902
    Item.find(ids_to_find)

    # @real=0.0001860000193119049
    items = Item.where(id: ids_to_find)
    # ------------------------------------------------------------

    # Expectation
    expect(items).to eq(expected_objects)
  end

  it '6. finds multiple orders by id' do
    ids_to_find = [@order_1.id, @order_3.id, @order_5.id, @order_7.id]

    # ----------------------- Using Ruby -------------------------
    # @real=0.15858900011517107
    # orders = Order.all.select { |order| ids_to_find.include?(order.id) }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    # @real=0.03791700000874698
    Order.all.select { |order| ids_to_find.include?(order.id) }

    # @real=0.039806999964639544
    Order.find([ids_to_find[1], ids_to_find[2], ids_to_find[0], ids_to_find[3]])

    # @real=0.04094600002281368
    Order.order(:id).find(ids_to_find)

    # @real=0.04245100007392466
    Order.find(ids_to_find)

    # @real=0.0031190000008791685
    orders = Order.where(id: ids_to_find)
    # ------------------------------------------------------------

    # Expectation
    expect(orders).to eq([@order_3, @order_5, @order_1, @order_7])
  end

  it '7. finds orders with an amount between 700 and 1000' do
    expected_result = [@order_11, @order_13, @order_8, @order_10, @order_15, @order_14, @order_12]
    # ----------------------- Using Ruby -------------------------
    # @real=0.2554030001629144
    # orders_between_700_and_1000 = Order.all.select { |order| order.amount >= 700 && order.amount <= 1000 }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # @real=0.01324799982830882
    # orders_between_700_and_1000 = Order.where('amount >= 700 and amount <= 1000')
    # @real=0.00014699995517730713
    orders_between_700_and_1000 = Order.where(amount: 700..1000)
    # ------------------------------------------------------------

    # Expectation
    expect(orders_between_700_and_1000).to eq(expected_result)
  end

  it '8. finds orders with an amount less than 550' do
    expected_result = [@order_3, @order_2, @order_1, @order_4]

    # ----------------------- Using Ruby -------------------------
    # orders_less_than_550 = Order.all.select { |order| order.amount < 550 }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # @real=0.0011579999700188637
    # orders_less_than_550 = Order.where('amount < 550')
    # @real=0.0001509999856352806
    # orders_less_than_550 = Order.where("amount < ?", 550)
    # @real=0.00016499985940754414
    orders_less_than_550 = Order.where(amount: 0...550)
    # ------------------------------------------------------------

    # Expectation
    expect(orders_less_than_550).to eq(expected_result)
  end
end
