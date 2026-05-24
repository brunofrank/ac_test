class CachedForecastService
  include Interactor

  CACHE_TTL = ENV.fetch('FORECAST_CACHE_TTL_IN_MINUTES', 30).to_i.minutes

  # > zip: String
  # > latitude: String
  # > longitude: String
  # < forecast_data: Hash
  # < from_cache: Boolean
  def call
    if cached?
      context.forecast_data = Rails.cache.read(cache_key)
      context.from_cache = true
    else
      result = ForecastService.call(
        latitude: latitude,
        longitude: longitude
      )

      if result.success?
        Rails.cache.write(cache_key, result.forecast_data, expires_in: CACHE_TTL)

        context.forecast_data = result.forecast_data
      else
        context.fail!(message: result.message)
      end
    end
  end

  private

  delegate :zip, :latitude, :longitude, to: :context

  def cached?
    @cached ||= Rails.cache.exist?(cache_key)
  end

  def cache_key
    "forecast/zip/#{zip}"
  end
end
