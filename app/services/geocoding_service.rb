class GeocodingService
  include Interactor

  # > address: String
  # < latitude
  # < longitude
  # < geo_data
  def call
    latitude, longitude = coordinates

    context.fail!(message: "Place not found") if latitude.blank? || longitude.blank?

    context.latitude = latitude
    context.longitude = longitude
  end

  private

  delegate :address, to: :context

  def geo_data
    context.geo_data = Geocoder.search(address).first
  end

  def coordinates
    @coordinates ||= geo_data&.coordinates
  end
end