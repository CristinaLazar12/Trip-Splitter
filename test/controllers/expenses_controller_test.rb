require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @trip  = trips(:one)
    @user  = users(:one)
    @non_creator = users(:two) 
    @expense = expenses(:correct_expense)     
    @expenses_users = expenses_users(:one)
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
    user_ids   = [@user.id, ""]

    assert_difference("Expense.count", +1) do
      post trip_expenses_url(@trip), params: {
        expense: {
          title:,
          amount:,
          currency:,
          date:,
          split_type:,
          payer_id:,
          user_ids: user_ids 
       } }
      end

    expense = Expense.last

    assert_equal expense.title,      title
    assert_equal expense.amount,     amount
    assert_equal expense.currency,   currency
    assert_equal expense.date,       date
    assert_equal expense.split_type, split_type
    assert_equal expense.payer,      @user
    assert_equal expense.user_ids,   [@user.id]

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

    @expense.reload

    assert_equal "Lunch", @expense.title  
    assert_equal 50, @expense.amount
    assert_equal "RON", @expense.currency
    assert_equal Date.new(2025, 10, 11), @expense.date
    assert_equal "equal", @expense.split_type
    assert_equal @user.id, @expense.payer_id

    assert_redirected_to trip_expense_url(@trip, @expense)
  end

  test "should destroy expense" do
    sign_in_as @user

    assert_difference("Expense.count", -1) do
      delete trip_expense_url(@trip, @expense)
    end 

    assert_redirected_to trip_url(@trip)
  end

  test "amount is split equally between the 2 participants" do
    sign_in_as @user
    #tre sa fac request cu post catre controller ca se creeaza expensul si ca se creaza expense user cu amountul meu
    post trip_expenses_url(@trip), params: {
        expense: {
          title: "Lunch",
          amount: 50,
          currency: "RON",
          date: Date.new(2025, 10, 11),
          split_type: "equal",
          payer_id: @user.id,
          user_ids: [@user.id, @non_creator.id]
       } }
       expense = Expense.last
       expense_user = expense.expenses_users.find_by(user_id: @user.id)
    assert_equal 25, expense_user.amount
  end

  test "expense is valid if payer is not a participant at expense" do
    sign_in_as @user
    post trip_expenses_url(@trip), params: {
        expense: {
          title: "Lunch",
          amount: 50,
          currency: "RON",
          date: Date.new(2025, 10, 11),
          split_type: "equal",
          payer_id: @user.id,
          user_ids: [@non_creator.id]
       } }
    expense = Expense.last
    expense.payer_id = @user.id
    #testul e valid daca payerul nu e in expenses_users
    assert_not expense.expenses_users.exists?(user_id: @user.id)
    assert expense.valid?
  end

  test "amount splits only once when payer is not a participant" do
    sign_in_as @user
    post trip_expenses_url(@trip), params: {
        expense: {
          title: "Lunch",
          amount: 50,
          currency: "RON",
          date: Date.new(2025, 10, 11),
          split_type: "equal",
          payer_id: @user.id,
          user_ids: [@non_creator.id]
       } }
    expense = Expense.last
    expense_user = expense.expenses_users.find_by(user_id: @non_creator.id)

    assert_equal 50, expense_user.amount
  end
end

  #user iau din fixtures
  #expense, expense_user le creez in controller
  #din fixtures iau ce nu e relevant pentru testul meu... ceva ce e creat deja, nu e relevant pentru test, ca nu asta testez,
  #dar imi trebuie sa iau
# sa verific ca pe expese_user e corect amountu