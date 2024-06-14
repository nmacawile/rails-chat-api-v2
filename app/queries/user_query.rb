class UserQuery
  def initialize(query_string)
    @query_string = query_string ? query_string.squish : ""
    @query_pattern = @query_string ? "%#{@query_string}%" : ""
  end

  def call
    return User.all if @query_string.blank?
    User.where(
      "CONCAT_WS(' ', first_name, last_name) " \
      "ILIKE ? OR " \
      "CONCAT_WS(' ', last_name, first_name) " \
      "ILIKE ? OR " \
      "handle ILIKE ? OR " \
      "email = ?", query_pattern, query_pattern, query_pattern, query_string)
  end

  private attr_reader :query_string, :query_pattern
end
