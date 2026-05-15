require "test_helper"

class UserAmountTest < ActiveSupport::TestCase

    setup do
        @creator = User.create(name: "Creator", email_address: "email@test.com", password: "password")
        @trip = Trip.create(name: "Barcelona", creator: @creator)

        @alex = User.create(name: "Alex", email_address: "alex@test.com", password: "password")
        @cristina = User.create(name: "Cristina", email_address: "cristina@test.com", password: "password")
        @vali = User.create(name: "Vali", email_address: "vali@test.com", password: "password")

        @users = [@alex, @cristina, @vali]
    end 

    test "amount a payer should receive" do
    
        expense = Expense.create(title: "avion", 
                                 amount: 300,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)
        @users.each do |user| 
            ExpensesUser.create!(expense_id: expense.id, user_id: user.id, amount: 100)
        end 

        assert_equal 200, UserAmount.new(@alex, @trip).amount_to_receive(expense) #alex
        assert_equal 0, UserAmount.new(@cristina, @trip).amount_to_receive(expense) #cristina
        assert_equal 0, UserAmount.new(@vali, @trip).amount_to_receive(expense) #Vali


        expense = Expense.create(title: "hotel", 
                                 amount: 150,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @vali,
                                 trip: @trip,
                                 split_type: :equal)

        @users.each do |user| 
            ExpensesUser.create!(expense_id: expense.id, user_id: user.id, amount: 75)
        end 

        assert_equal 150, UserAmount.new(@vali, @trip).amount_to_receive(expense) #vali
        assert_equal 0, UserAmount.new(@cristina, @trip).amount_to_receive(expense) #cristina
        assert_equal 0, UserAmount.new(@alex, @trip).amount_to_receive(expense) #alex

        expense = Expense.create(title: "shopping", 
                                 amount: 100,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)
        
        ExpensesUser.create!(expense_id: expense.id, user_id: @cristina.id, amount: 100)

        assert_equal 100, UserAmount.new(@alex, @trip).amount_to_receive(expense) #alex
        assert_equal 0, UserAmount.new(@cristina, @trip).amount_to_receive(expense) #cristina
        assert_equal 0, UserAmount.new(@vali, @trip).amount_to_receive(expense) #vali
        

        expense = Expense.create(title: "meci fotbal", 
                                 amount: 200,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)

       
        ExpensesUser.create!(expense_id: expense.id, user_id: @alex.id, amount: 100)
        ExpensesUser.create!(expense_id: expense.id, user_id: @vali.id, amount: 100)
        
        assert_equal 100, UserAmount.new(@alex, @trip).amount_to_receive(expense) #alex
        assert_equal 0, UserAmount.new(@vali, @trip).amount_to_receive(expense) #vali
        assert_equal 0, UserAmount.new(@cristina, @trip).amount_to_receive(expense) #cristina

    end

    test "amount a participant should pay" do

        expense = Expense.create(title: "avion", 
                                 amount: 300,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)
        @users.each do |user| 
            ExpensesUser.create!(expense_id: expense.id, user_id: user.id, amount: 100)
        end 

        assert_equal 0, UserAmount.new(@alex, @trip).amount_to_pay(expense) #alex
        assert_equal 100, UserAmount.new(@cristina, @trip).amount_to_pay(expense) #cristina
        assert_equal 100, UserAmount.new(@vali, @trip).amount_to_pay(expense) #Vali

        expense = Expense.create(title: "hotel", 
                                 amount: 150,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @vali,
                                 trip: @trip,
                                 split_type: :equal)

        @users.each do |user| 
            ExpensesUser.create!(expense_id: expense.id, user_id: user.id, amount: 75)
        end 

        assert_equal 0, UserAmount.new(@vali, @trip).amount_to_pay(expense) #vali
        assert_equal 75, UserAmount.new(@cristina, @trip).amount_to_pay(expense) #cristina
        assert_equal 75, UserAmount.new(@alex, @trip).amount_to_pay(expense) #alex

        expense = Expense.create(title: "shopping", 
                                 amount: 100,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)
        
        ExpensesUser.create!(expense_id: expense.id, user_id: @cristina.id, amount: 100)

        assert_equal 0, UserAmount.new(@alex, @trip).amount_to_pay(expense) #alex
        assert_equal 100, UserAmount.new(@cristina, @trip).amount_to_pay(expense) #cristina
        assert_equal 0, UserAmount.new(@vali, @trip).amount_to_pay(expense) #vali
        

        expense = Expense.create(title: "meci fotbal", 
                                 amount: 200,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)
       
        ExpensesUser.create!(expense_id: expense.id, user_id: @alex.id, amount: 100)
        ExpensesUser.create!(expense_id: expense.id, user_id: @vali.id, amount: 100)
        
        assert_equal 0, UserAmount.new(@alex, @trip).amount_to_pay(expense) #alex
        assert_equal 100, UserAmount.new(@vali, @trip).amount_to_pay(expense) #vali
        assert_equal 0, UserAmount.new(@cristina, @trip).amount_to_pay(expense) #cristina
    end

    test "amount the payer should receive after first expense" do
        expense = Expense.create(title: "avion", 
                                 amount: 300,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)
        @users.each do |user| 
            ExpensesUser.create!(expense_id: expense.id, user_id: user.id, amount: 100)
        end 

        assert_equal 200, UserAmount.new(@alex, @trip).total_to_receive #alex
        assert_equal 0, UserAmount.new(@cristina, @trip).total_to_receive #cristina
        assert_equal 0, UserAmount.new(@vali, @trip).total_to_receive #Vali
    end

    test "amount the payer should receive after second expense" do
        expense = Expense.create(title: "hotel", 
                                 amount: 150,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @vali,
                                 trip: @trip,
                                 split_type: :equal)

        
        ExpensesUser.create!(expense_id: expense.id, user_id: @alex.id, amount: 75)
        ExpensesUser.create!(expense_id: expense.id, user_id: @cristina.id, amount: 75)
        
        assert_equal 150, UserAmount.new(@vali, @trip).total_to_receive #vali
        assert_equal 0, UserAmount.new(@cristina, @trip).total_to_receive #cristina
        assert_equal 0, UserAmount.new(@alex, @trip).total_to_receive #alex
    end

    test "amount the payer should receive after third expense" do
        expense = Expense.create(title: "shopping", 
                                 amount: 100,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)
        
        ExpensesUser.create!(expense_id: expense.id, user_id: @cristina.id, amount: 100)

        assert_equal 100, UserAmount.new(@alex, @trip).total_to_receive #alex
        assert_equal 0, UserAmount.new(@cristina, @trip).total_to_receive #cristina
        assert_equal 0, UserAmount.new(@vali, @trip).total_to_receive #vali
    end

    test "amount the payer should receive after forth expense" do
        expense = Expense.create(title: "meci fotbal", 
                                 amount: 200,
                                 currency: "EUR",
                                 date: Date.today,
                                 payer: @alex,
                                 trip: @trip,
                                 split_type: :equal)
       
        ExpensesUser.create!(expense_id: expense.id, user_id: @alex.id, amount: 100)
        ExpensesUser.create!(expense_id: expense.id, user_id: @vali.id, amount: 100)
        
        assert_equal 100, UserAmount.new(@alex, @trip).total_to_receive #alex
        assert_equal 0, UserAmount.new(@vali, @trip).total_to_receive #vali
        assert_equal 0, UserAmount.new(@cristina, @trip).total_to_receive #cristina
    end

    test "total amount a participant should pay" do
    end

    test "balance a participant should have at the end of a trip" do
    end
end

#sa rulez testul pt fiecare, primda data trebuie sa treaca pt alex, apoi pt cristina si vali
# dupa ce trece testul pentru un expense, scriu test pentru urmatoru expense, si pt fiecare pe rand