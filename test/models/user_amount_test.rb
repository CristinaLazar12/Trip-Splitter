require "test_helper"

class UserAmountTest < ActiveSupport::TestCase

    setup do
        @creator = User.create!(name: "Creator", email_address: "email@test.com", password: "password")
        @trip = Trip.create!(name: "Barcelona", creator: @creator)

        @alex = User.create!(name: "Alex", email_address: "alex@test.com", password: "password")
        @cristina = User.create!(name: "Cristina", email_address: "cristina@test.com", password: "password")
        @vali = User.create!(name: "Vali", email_address: "vali@test.com", password: "password")

        @users = [@alex, @cristina, @vali]
    end 

    test "amount a payer should receive" do
    
        expense = Expense.create!(title: "avion", 
                                 amount: 300,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)
        @users.each do |user| 
            ExpensesUser.create!(expense_id: expense.id, user_id: user.id, amount: 100)
        end 

        assert_equal 200, UserAmount.new(@alex.id, @trip.id).amount_to_receive(expense) #alex
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).amount_to_receive(expense) #cristina
        assert_equal 0, UserAmount.new(@vali.id, @trip.id).amount_to_receive(expense) #Vali

        assert_equal 0, UserAmount.new(@alex.id, @trip.id).amount_to_pay(expense) #alex
        assert_equal 100, UserAmount.new(@cristina.id, @trip.id).amount_to_pay(expense) #cristina
        assert_equal 100, UserAmount.new(@vali.id, @trip.id).amount_to_pay(expense) #Vali

        assert_equal 200, UserAmount.new(@alex.id, @trip.id).total_to_receive #alex
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).total_to_receive #cristina
        assert_equal 0, UserAmount.new(@vali.id, @trip.id).total_to_receive #Vali

        assert_equal 0, UserAmount.new(@alex.id, @trip.id).total_to_pay #alex
        assert_equal 100, UserAmount.new(@cristina.id, @trip.id).total_to_pay #cristina
        assert_equal 100, UserAmount.new(@vali.id, @trip.id).total_to_pay #Vali

        expense = Expense.create!(title: "hotel", 
                                 amount: 150,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @vali,
                                 trip: @trip,
                                 split_type: :equal)

        
        ExpensesUser.create!(expense_id: expense.id, user_id: @cristina.id, amount: 75)
        ExpensesUser.create!(expense_id: expense.id, user_id: @alex.id, amount: 75)
        binding.pry
        assert_equal 150, UserAmount.new(@vali.id, @trip.id).amount_to_receive(expense) #vali
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).amount_to_receive(expense) #cristina
        assert_equal 0, UserAmount.new(@alex.id, @trip.id).amount_to_receive(expense) #alex

        assert_equal 0, UserAmount.new(@vali.id, @trip.id).amount_to_pay(expense) #vali
        assert_equal 75, UserAmount.new(@cristina.id, @trip.id).amount_to_pay(expense) #cristina
        assert_equal 75, UserAmount.new(@alex.id, @trip.id).amount_to_pay(expense) #alex

        assert_equal 150, UserAmount.new(@vali.id, @trip.id).total_to_receive #vali
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).total_to_receive #cristina
        assert_equal 200, UserAmount.new(@alex.id, @trip.id).total_to_receive #alex

        assert_equal 100, UserAmount.new(@vali.id, @trip.id).total_to_pay #vali
        assert_equal 175, UserAmount.new(@cristina.id, @trip.id).total_to_pay #cristina
        assert_equal 75, UserAmount.new(@alex.id, @trip.id).total_to_pay #alex

        expense = Expense.create!(title: "shopping", 
                                 amount: 100,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)
        
        ExpensesUser.create!(expense_id: expense.id, user_id: @cristina.id, amount: 100)

        assert_equal 100, UserAmount.new(@alex.id, @trip.id).amount_to_receive(expense) #alex
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).amount_to_receive(expense) #cristina
        assert_equal 0, UserAmount.new(@vali.id, @trip.id).amount_to_receive(expense) #vali

        assert_equal 0, UserAmount.new(@alex.id, @trip.id).amount_to_pay(expense) #alex
        assert_equal 100, UserAmount.new(@cristina.id, @trip.id).amount_to_pay(expense) #cristina
        assert_equal 0, UserAmount.new(@vali.id, @trip.id).amount_to_pay(expense) #vali

        assert_equal 300, UserAmount.new(@alex.id, @trip.id).total_to_receive #alex
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).total_to_receive #cristina
        assert_equal 150, UserAmount.new(@vali.id, @trip.id).total_to_receive #vali

        assert_equal 75, UserAmount.new(@alex.id, @trip.id).total_to_pay #alex
        assert_equal 275, UserAmount.new(@cristina.id, @trip.id).total_to_pay #cristina
        assert_equal 100, UserAmount.new(@vali.id, @trip.id).total_to_pay #vali


        expense = Expense.create!(title: "meci fotbal", 
                                 amount: 200,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)

       
        ExpensesUser.create!(expense_id: expense.id, user_id: @alex.id, amount: 100)
        ExpensesUser.create!(expense_id: expense.id, user_id: @vali.id, amount: 100)
        
        assert_equal 100, UserAmount.new(@alex.id, @trip.id).amount_to_receive(expense) #alex
        assert_equal 0, UserAmount.new(@vali.id, @trip.id).amount_to_receive(expense) #vali
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).amount_to_receive(expense) #cristina

        assert_equal 0, UserAmount.new(@alex.id, @trip.id).amount_to_pay(expense) #alex
        assert_equal 100, UserAmount.new(@vali.id, @trip.id).amount_to_pay(expense) #vali
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).amount_to_pay(expense) #cristina

        assert_equal 400, UserAmount.new(@alex.id, @trip.id).total_to_receive #alex
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).total_to_receive #cristina
        assert_equal 150, UserAmount.new(@vali.id, @trip.id).total_to_receive #vali

        assert_equal 75, UserAmount.new(@alex.id, @trip.id).total_to_pay #alex
        assert_equal 275, UserAmount.new(@cristina.id, @trip.id).total_to_pay #cristina
        assert_equal 200, UserAmount.new(@vali.id, @trip.id).total_to_pay #vali

    end
end

