class Rack::Attack
  # Throttle POST requests to /reviews by email address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:reviews/email:#{req.email}"
  throttle('reviews/email', limit: 2, period: 2.minutes) do |req|
    if req.path == '/reviews' && req.post?
      # return the email if present, nil otherwise
      req.params['email'].presence
    end
  end
end
