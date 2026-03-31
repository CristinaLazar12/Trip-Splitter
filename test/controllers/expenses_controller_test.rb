require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @trip  = trips(:one)
    @user  = users(:one)
    @non_creator = users(:two) 
    @expense = expenses(:correct_expense)     
  end

  test "should get index" do
    sign_in_as @user #se logheaza ca si creator
    get trip_expenses_url(@trip)
    assert_response :success
  end

  test "should get new" do
    sign_in_as @user #se logheaza ca si creator
    get new_trip_expense_url(@trip)
    assert_response :success
  end

  test "should create expense" do
    sign_in_as @user 

    title      = "Lunch"
    amount     = 50
    currency   = "RON"
    date       = Date.new(2025, 10, 11)
    split_type = "equal"
    payer_id   = @user.id
    user_ids   = [@user.id]

    assert_difference("Expense.count", +1) do
      post trip_expenses_url(@trip), params: { 
        expense: {
          title:,
          amount:,
          currency:,
          date:,
          split_type:,
          payer_id: 
      }, 
      user_ids: user_ids } 
      end

    expense = Expense.last

    assert_equal expense.title,      title
    assert_equal expense.amount,     amount
    assert_equal expense.currency,   currency
    assert_equal expense.date,       date
    assert_equal expense.split_type, split_type
    assert_equal expense.payer,      @user

    assert_redirected_to trip_url(@trip)
  end

  test "should show expense" do
    sign_in_as @user #se logheaza ca si creator
    get trip_expense_url(@trip, @expense)
    assert_response :success
  end

  test "should edit expense" do
    sign_in_as @user
    get edit_trip_expense_url(@trip, @expense)
    assert_response :success
  end

  test "should update expense" do
    sign_in_as @user
    patch trip_expense_url(@trip, @expense), params: { expense: {
      title: "Lunch",
      amount: 50,
      currency: "RON",
      date: Date.new(2025, 10, 11),
      split_type: "equal",
      payer_id: @user.id 
    }}  

    assert_redirected_to trip_expense_url(@trip, @expense)
  end

  test "should destroy expense" do
    sign_in_as @user

    assert_difference("Expense.count", -1) do
      delete trip_expense_url(@trip, @expense)
    end 

    assert_redirected_to trip_url(@trip)
  end
end
