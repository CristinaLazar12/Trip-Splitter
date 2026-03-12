require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @trip  = trips(:one)
    @user  = users(:one)
    @non_creator = users(:two) 
    @expense = expenses(:one)     
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

    assert_difference("Expense.count") do
        post trip_expenses_url(@trip), params: { expense: {
            title: "Lunch",
            amount: 50,
            currency: "RON",
            date: Date.new(2025, 10, 11),
            split_type: "equal",
            payer_id: @user.id 
        } }
        end

        assert_redirected_to trip_expense_url(@trip, Expense.last)
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
    patch trip_expense_url(@trip, @expense)
    assert_response :success
  end

  test "should destroy expense" do
    sign_in_as @user
    delete trip_expense_url(@trip, @expense)
    assert_response :success
  end
end
