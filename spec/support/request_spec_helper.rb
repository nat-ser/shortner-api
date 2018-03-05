# frozen_string_literal: true

# helper methods for request specs
module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end
end
