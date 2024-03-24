json.extract! car, :id, :brand, :model, :year, :color, :mileage, :availability, :location, :rental_price, :insurance, :image, :user_id, :created_at, :updated_at
json.url car_url(car, format: :json)
