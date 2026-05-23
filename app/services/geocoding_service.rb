class GeocodingService
  include Interactor

  # > city: String
  # > state: String
  # < latitude
  # < longitude
  def call
    latitude, longitude = get_coordinates

    context.fail!(message: "Place not found") if latitude.blank? || longitude.blank?

    context.latitude = latitude
    context.longitude = longitude
  end

  private

  delegate :city, :state, to: :context

  def city_with_state
    [city, state].join(', ')
  end

  def get_coordinates
    results = Geocoder.search(city_with_state)

    results.first&.coordinates
  end
end