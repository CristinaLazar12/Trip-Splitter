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

        assert_equal 200, UserAmount.new(@alex.id, @trip.id).total_to_receive("EUR") #alex
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).total_to_receive("EUR") #cristina
        assert_equal 0, UserAmount.new(@vali.id, @trip.id).total_to_receive("EUR") #Vali

        assert_equal 0, UserAmount.new(@alex.id, @trip.id).total_to_pay("EUR") #alex
        assert_equal 100, UserAmount.new(@cristina.id, @trip.id).total_to_pay("EUR") #cristina
        assert_equal 100, UserAmount.new(@vali.id, @trip.id).total_to_pay("EUR") #Vali

        assert_equal 200, UserAmount.new(@alex.id, @trip.id).final_balance("EUR") #alex
        assert_equal -100, UserAmount.new(@cristina.id, @trip.id).final_balance("EUR") #cristina
        assert_equal -100, UserAmount.new(@vali.id, @trip.id).final_balance("EUR") #Vali

        expense = Expense.create!(title: "hotel", 
                                 amount: 150,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @vali,
                                 trip: @trip,
                                 split_type: :equal)

        
        ExpensesUser.create!(expense_id: expense.id, user_id: @cristina.id, amount: 75)
        ExpensesUser.create!(expense_id: expense.id, user_id: @alex.id, amount: 75)

        assert_equal 150, UserAmount.new(@vali.id, @trip.id).amount_to_receive(expense) #vali
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).amount_to_receive(expense) #cristina
        assert_equal 0, UserAmount.new(@alex.id, @trip.id).amount_to_receive(expense) #alex

        assert_equal 0, UserAmount.new(@vali.id, @trip.id).amount_to_pay(expense) #vali
        assert_equal 75, UserAmount.new(@cristina.id, @trip.id).amount_to_pay(expense) #cristina
        assert_equal 75, UserAmount.new(@alex.id, @trip.id).amount_to_pay(expense) #alex

        assert_equal 150, UserAmount.new(@vali.id, @trip.id).total_to_receive("EUR") #vali
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).total_to_receive("EUR") #cristina
        assert_equal 200, UserAmount.new(@alex.id, @trip.id).total_to_receive("EUR") #alex

        assert_equal 100, UserAmount.new(@vali.id, @trip.id).total_to_pay("EUR") #vali
        assert_equal 175, UserAmount.new(@cristina.id, @trip.id).total_to_pay("EUR") #cristina
        assert_equal 75, UserAmount.new(@alex.id, @trip.id).total_to_pay("EUR") #alex

        assert_equal 50, UserAmount.new(@vali.id, @trip.id).final_balance("EUR") #Vali
        assert_equal -175, UserAmount.new(@cristina.id, @trip.id).final_balance("EUR") #cristina
        assert_equal 125, UserAmount.new(@alex.id, @trip.id).final_balance("EUR") #alex

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

        assert_equal 300, UserAmount.new(@alex.id, @trip.id).total_to_receive("EUR") #alex
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).total_to_receive("EUR") #cristina
        assert_equal 150, UserAmount.new(@vali.id, @trip.id).total_to_receive("EUR") #vali

        assert_equal 75, UserAmount.new(@alex.id, @trip.id).total_to_pay("EUR") #alex
        assert_equal 275, UserAmount.new(@cristina.id, @trip.id).total_to_pay("EUR") #cristina
        assert_equal 100, UserAmount.new(@vali.id, @trip.id).total_to_pay("EUR") #vali

        assert_equal 225, UserAmount.new(@alex.id, @trip.id).final_balance("EUR") #alex
        assert_equal -275, UserAmount.new(@cristina.id, @trip.id).final_balance("EUR") #cristina
        assert_equal 50, UserAmount.new(@vali.id, @trip.id).final_balance("EUR") #vali


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

        assert_equal 400, UserAmount.new(@alex.id, @trip.id).total_to_receive("EUR") #alex
        assert_equal 0, UserAmount.new(@cristina.id, @trip.id).total_to_receive("EUR") #cristina
        assert_equal 150, UserAmount.new(@vali.id, @trip.id).total_to_receive("EUR") #vali

        assert_equal 75, UserAmount.new(@alex.id, @trip.id).total_to_pay("EUR") #alex
        assert_equal 275, UserAmount.new(@cristina.id, @trip.id).total_to_pay("EUR") #cristina
        assert_equal 200, UserAmount.new(@vali.id, @trip.id).total_to_pay("EUR") #vali

        assert_equal 325, UserAmount.new(@alex.id, @trip.id).final_balance("EUR") #alex
        assert_equal -275, UserAmount.new(@cristina.id, @trip.id).final_balance("EUR") #cristina
        assert_equal -50, UserAmount.new(@vali.id, @trip.id).final_balance("EUR") #vali
    end

    test "final balance is calculated separately by currency" do
        expense_eur = Expense.create!(
            title: "Hotel",
            amount: 100,
            currency: "EUR",
            date: Date.today,
            payer: @alex,
            trip: @trip,
            split_type: :equal
        )

        ExpensesUser.create!(
            expense_id: expense_eur.id,
            user_id: @cristina.id,
            amount: 50
        )

        expense_ron = Expense.create!(
            title: "Dinner",
            amount: 200,
            currency: "RON",
            date: Date.today,
            payer: @alex,
            trip: @trip,
            split_type: :equal
        )

        ExpensesUser.create!(
            expense_id: expense_ron.id,
            user_id: @cristina.id,
            amount: 100
        ) 

        user_amount = UserAmount.new(@alex.id, @trip.id)

        assert_equal 50, user_amount.final_balance("EUR")
        assert_equal 100, user_amount.final_balance("RON")
    end
end

