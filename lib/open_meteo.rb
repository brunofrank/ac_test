class OpenMeteo
  include HTTParty

  BASE_URL = "https://api.open-meteo.com/v1/forecast"

  def self.forecast(latitude:, longitude:)
    get(BASE_URL, query: {
      latitude: latitude,
      longitude: longitude,
      current: "temperature_2m,apparent_temperature,weather_code",
      daily: "temperature_2m_max,temperature_2m_min,weather_code",
      temperature_unit: "fahrenheit",
      forecast_days: 7,
      timezone: "auto"
    })
  end
end