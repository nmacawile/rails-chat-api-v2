class UserQuery
  def initialize(query_string)
    @query_string = "%#{query_string.squish}%"
  end

  def call
    User.where(
      "CONCAT_WS(' ', first_name, last_name) " \
      "ILIKE ? OR " \
      "CONCAT_WS(' ', last_name, first_name) " \
      "ILIKE ?", query_string, query_string)
  end

  private attr_reader :query_string
end
