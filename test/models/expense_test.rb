require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
    test "invalid without a title" do
        expense = Expense.new #expenseul e invalid fara un titlu, deci nu trecem aici nume
        assert expense.invalid? #expensul este invalid
        assert_includes expense.errors[:title], "can't be blank"
    end

    test "invalid without an amount" do 
        expense = Expense.new
        assert expense.invalid?
        assert_includes expense.errors[:amount], "can't be blank"
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

    test "invalid without a split_type" do 
        expense = Expense.new
        assert expense.invalid?
        assert_includes expense.errors[:split_type], "can't be blank"
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

end
