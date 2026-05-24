class HomeController < ApplicationController
  def index
  end

  def forecast
    zip = params[:zip]
    result = GeocodingService.call(address: zip)

    if result.success?
      @location = result.geo_data.address

      result = CachedForecastService.call(
        zip: zip,
        latitude: result.geo_data.latitude,
        longitude: result.geo_data.longitude
      )

      @from_cache = result.from_cache
      @forecast = result.forecast_data
    end
  end
end
