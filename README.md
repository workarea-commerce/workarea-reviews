Workarea Reviews
================================================================================

A Workarea Commerce plugin that enables product reviews.


Overview
--------------------------------------------------------------------------------

* Consumers can write product reviews in the Storefront
* Admins can edit those reviews in the Admin, which includes approving them
* Approved reviews are reflected in product summaries and displayed on product detail pages
* Consumers can sort products by rating in the Storefront
* Admins can list, show, edit, and delete reviews in the Admin
* Admins can view and navigate to a product's reviews when administrating a product in the Admin
* The Admin daily status report email includes a summary of reviews
* The system emails consumers who place orders to request they write reviews
* Developers can seed reviews for all products
* Developers can preview review-related emails
* Admins can view a reviews by product report
* The system generates top rated and most reviewed product insights
* The system generates most active reviewers insight

Getting Started
--------------------------------------------------------------------------------

Add the gem to your application's Gemfile:

```ruby
# ...
gem 'workarea-reviews'
# ...
```

Update your application's bundle.

```bash
cd path/to/application
bundle
```

Features
--------------------------------------------------------------------------------


### Writing Reviews

* Reviews are written in the Storefront; users may be logged in or anonymous (requires reCAPTCHA)
* Developers can set `Workarea.config.require_purchase_to_write_review` to `true` to require the reviewer to have a `total_spent` greater than zero for the review to be valid
* The "write review" form is presented as a dialog, which closes after the review is submitted
* The reviewer uses a rating star UI (with underlying values of 1 through 5) to select a rating
* The reviewer may also provide a title and body, along with their first name, last name, and email
* The reviewer receives an email to confirm the review was submitted and is awaiting admin approval


### Displaying Reviews

* In the Storefront, reviews are presented without pagination
* Reviews can be sorted, which is handled client-side (values are oldest, newest, and highest)
* Each review may include a title, a body, and the following metadata: author, date, verified
* A review is considered verified if the reviewer was logged in and has the ID of the reviewed product in their order history


### Administrating Reviews

* Admins with marketing permission may access the reviews admin
* The reviews admin is accessible from the Marketing section of the primary navigation and from the Marketing dashboard
* Admins can also jump to the reviews admin by searching for "Product Reviews"
* Products and reviews are cross referenced within the auxillary navigation of each
* Admins can list, show, edit, and delete reviews, which includes approving them (Admins can edit a review before approving)


### Requesting Reviews

* For each order, the system will send up to _n_ review requests (Workarea.config.review_requests_per_order)
* Each request is for a different order item (selected by most expensive)
* Each request expires after a configurable duration (Workarea.config.review_request_ttl)
* The first request is sent after a configurable duration has passed (Workarea.config.review_request_initial_delivery_delay)
* Each consecutive request is sent at a configurable duration (Workarea.config.review_request_secondary_delivery_delay)

reCAPTCHA Configuration
--------------------------------------------------------------------------------

Workarea Reviews utilizes [reCAPTCHA](https://github.com/ambethia/recaptcha) in the review form to prevent abuse. You'll need to configure each environment's secrets file to provide recaptcha keys. For testing and development, the plugin will use the [google provided](https://developers.google.com/recaptcha/docs/faq) testing keys if none are specified in your secrets.

```yaml
production:
  recaptcha:
    site_key: YOUR_SITE_KEY
    secret_key: YOUR_SECRET_KEY
```

reCAPTCHA sends its HTTP requests through the proxy automatically if the
`$HTTP_PROXY` environment variable is set. This is set for you in hosted
environments.

[Obtain your keys from the reCAPTCHA site](https://www.google.com/recaptcha/admin)

Workarea Commerce Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea Commerce documentation.

License
--------------------------------------------------------------------------------

Workarea Reviews is released under the [Business Software License](LICENSE)
