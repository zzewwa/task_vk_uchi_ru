class InteractorResult
  attr_reader :data, :error_code, :errors, :status, :headers

  def initialize(success:, data: {}, error_code: nil, errors: {}, status: :ok, headers: {})
    @success = success
    @data = data
    @error_code = error_code
    @errors = errors
    @status = status
    @headers = headers
  end

  def success?
    @success
  end
end

class ApplicationInteractor
  private

  def success(data: {}, status: :ok, headers: {})
    InteractorResult.new(success: true, data: data, status: status, headers: headers)
  end

  def failure(error_code:, errors:, status: :bad_request)
    InteractorResult.new(success: false, error_code: error_code, errors: errors, status: status)
  end
end
