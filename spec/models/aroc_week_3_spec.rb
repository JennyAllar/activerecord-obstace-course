require 'rails_helper'
require 'byebug'

describe 'ActiveRecord Obstacle Course, Week 3' do

# Looking for your test setup data?
# It's currently inside /spec/rails_helper.rb
# Not a very elegant solution, but works for this iteration.

# Here are the docs associated with ActiveRecord queries: http://guides.rubyonrails.org/active_record_querying.html

# ----------------------


  it '16. returns the names of users who ordered one specific item' do
    expected_result = [@user_2.name, @user_3.name, @user_1.name]

    # ----------------------- Using Raw SQL-----------------------
    # @real=0.009393999818712473
    # users = ActiveRecord::Base.connection.execute("
    #   select
    #     distinct users.name
    #   from users
    #     join orders on orders.user_id=users.id
    #     join order_items ON order_items.order_id=orders.id
    #   where order_items.item_id=#{item_8.id}
    #   ORDER BY users.name")
    # users = users.map {|u| u['name']}
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # @real=0.013429999817162752
    users = User.select(:name).joins(:orders).distinct.joins(:items).order(:name)
    # @real=0.03507799981161952
    users = User.joins(orders: :order_items).distinct.where(order_items: {item_id: @item_8.id}).pluck(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(users).to eq(expected_result)
  end

  it '17. returns the name of items associated with a specific order' do
    expected_result = ['Abercrombie', 'Giorgio Armani', 'J.crew', 'Fox']

    # ----------------------- Using Ruby -------------------------
    # @real=0.015658000018447638
    names = Order.last.items.all.map(&:name)
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # @real=0.0376199996098876
    names = Item.select(:name).joins(:order_items).distinct.where(order_items: {order_id: Order.last.id}).pluck(:name)
    # @real=0.00861399993300438
    names = Order.last.items.pluck(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(names.sort).to eq(expected_result.sort)
  end

  it '18. returns the names of items for a users order' do
    expected_result = ['Giorgio Armani', 'Banana Republic', 'Izod', 'Fox']

    # ----------------------- Using Ruby -------------------------
    items_for_user_3_third_order = []
    # grouped_orders = []
    # Order.all.each do |order|
    #   if order.items
    #     grouped_orders << order if order.user_id == @user_3.id
    #   end
    # end
    # grouped_orders.each_with_index do |order, idx|
    #   items_for_user_3_third_order = order.items.map(&:name) if idx == 2
    # end
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    # @real=0.0031869999947957695
    items_for_user_3_third_order = Item.joins(:order_items).where(order_items: {order_id: Order.where(user_id: @user_3.id).third.id}).pluck(:name)
    # @real=0.002390999987255782
    items_for_user_3_third_order = Order.where(user_id: @user_3.id).third.items.pluck(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(items_for_user_3_third_order.sort).to eq(expected_result.sort)
  end

  it '19. returns the average amount for all orders' do
    # ---------------------- Using Ruby -------------------------
    average = (Order.all.map(&:amount).inject(:+)) / (Order.count)
    # -----------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    # ------------------------------------------------------------

    # Expectation
    expect(average).to eq(650)
  end

  it '20. returns the average amount for all orders for one user' do
    # ---------------------- Using Ruby -------------------------
    orders = Order.all.map do |order|
      order if order.user_id == @user_3.id
    end.select{|i| !i.nil?}
    
    average = (orders.map(&:amount).inject(:+)) / (orders.count)
    # -----------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    # ------------------------------------------------------------

    # Expectation
    expect(average.to_i).to eq(749)
  end
end
