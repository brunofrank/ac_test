class ForecastService
  include Interactor

  # > latitude: String
  # > longitude: String
  # < forecast_data: Hash
  def call
    response = OpenMeteo.forecast(latitude: latitude, longitude: longitude)

    context.fail!(message: "Weather data unavailable") unless response.success?

    context.forecast_data = {
      current: response.parsed_response["current"],
      daily:   response.parsed_response["daily"]
    }
  end

  private

  delegate :latitude, :longitude, to: :context
end