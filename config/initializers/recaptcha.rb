recaptcha =
  if Rails.application.secrets.recaptcha.present?
    Rails.application.secrets.recaptcha.symbolize_keys
  elsif Rails.env.development? || Rails.env.test?
    # These are keys provided by google for the purpose of testing.
    # See https://developers.google.com/recaptcha/docs/faq
    {
      site_key: '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI',
      secret_key: '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe'
    }
  end

if recaptcha.present?
  Recaptcha.configure do |config|
    config.site_key = recaptcha[:site_key]
    config.secret_key = recaptcha[:secret_key]
    config.proxy = ENV.fetch('HTTP_PROXY', (recaptcha[:proxy] if recaptcha[:proxy].present?))
  end
end
