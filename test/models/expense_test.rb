require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
    test "invalid without a title" do
        expense = Expense.new #expenseul e invalid fara un titlu, deci nu trecem aici nume
        assert expense.invalid? #expensul este invalid
        assert_includes expense.errors[:title], "can't be blank"
    end

    test "invalid without a currency" do 
        expense = Expense.new
        assert expense.invalid?
        assert_includes expense.errors[:currency], "can't be blank"
    end

    test "invalid without a date" do 
        expense = Expense.new
        assert expense.invalid?
        assert_includes expense.errors[:date], "can't be blank"
    end

    test "invalid without a trip" do 
        expense = Expense.new
        assert expense.invalid?
        assert_includes expense.errors[:trip], "must exist"
    end

    test "invalid without a payer" do 
        expense = Expense.new
        assert expense.invalid?
        assert_includes expense.errors[:payer], "must exist"
    end

    test "invalid when amount is 0" do
        expense = Expense.new(amount: 0)
        assert expense.invalid?
        assert_includes expense.errors[:amount], "must be greater than 0"
    end

    test "invalid when amount is negative" do
        expense = Expense.new(amount: -10)
        assert expense.invalid?
        assert_includes expense.errors[:amount], "must be greater than 0"
    end

    test "expense valid with all the attributes" do
        creator = users(:one)
        trip = trips(:one)

        expense = Expense.new(
            title: "Dinner",
            amount: 80,
            currency: "RON",
            date: Date.new(2025, 10, 10),
            split_type: "equal",
            trip: trip,
            payer: creator
        )

        assert expense.valid?
    end

    test "expense can have participants" do
        creator = users(:one)
        trip = trips(:one)
        other_user = users(:two)

        expense = Expense.new(
            title: "Dinner",
            amount: 80,
            currency: "RON",
            date: Date.new(2025, 10, 10),
            split_type: "equal",
            trip: trip,
            payer: creator
        )
        binding.pry
        expense.users << creator
        expense.users << other_user

        assert expense.valid?
        assert_includes expense.users, creator
        assert_includes expense.users, other_user
    end
end
