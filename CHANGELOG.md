Workarea Reviews 3.0.9 (2019-08-26)
--------------------------------------------------------------------------------

* Only try to add schedule job if service connections are not skipped



Workarea Reviews 3.0.8 (2019-08-21)
--------------------------------------------------------------------------------

*   Open Source!



Workarea Reviews 3.0.7 (2019-06-11)
--------------------------------------------------------------------------------

*   Add Rake Task for Reconciling Verified Purchasers

    Reviews can have a `:verified` badge associated with the content, but
    for those upgrading to a newer version some data needs to be changed in
    order to make this happen retroactively for older reviews. Add a Rake
    task for adding the `:verified` field to reviews where the user actually
    bought the product. For any reviews that are made after the upgrade,
    this will be automatically assigned as the review is being created.

    REVIEWS-146
    Tom Scott



Workarea Reviews 3.0.6 (2019-04-16)
--------------------------------------------------------------------------------

*   Automatically Configure reCAPTCHA Proxy

    Set the `Recaptcha.config.proxy` to `$HTTP_PROXY` in deployed
    environments so developers don't have to worry about it. Update the
    README to remove references to this configuration setting.

    REVIEWS-144
    Tom Scott

*   Point Gemfile to gem server

    Curt Howard



Workarea Reviews 3.0.5 (2019-03-19)
--------------------------------------------------------------------------------

*   Fix Browsing Controls UI

    REVIEWS-140
    Curt Howard

*   Update for workarea v3.4 compatibility

    REVIEWS-139
    Matt Duffy



Workarea Reviews 3.0.4 (2019-01-22)
--------------------------------------------------------------------------------

*   Improve readme

    ECOMMERCE-6523
    REVIEWS-138
    Chris Cressman



Workarea Reviews 3.0.3 (2018-10-30)
--------------------------------------------------------------------------------

*   Change DateTime to Time in ScheduleReviewRequestsTests

    Assertions began failing due to difference in nanoseconds, uncertain why but using Time instead of DateTime is a safe resolution.

    REVIEWS-137
    Francis Bongiovanni

*   Extend list-reset trump for review group UI

    REVIEWS-136
    Curt Howard



Workarea Reviews 3.0.2 (2018-07-24)
--------------------------------------------------------------------------------

*   Add rack attack throttle for review submissions

    REVIEWS-132
    Matt Duffy

*   Fix Missing Title When Submitting Review

    Previously, all reviews had the title and the body equal because the
    title was not being passed through properly in params. We're now passing
    the `title:` attribute into the Review model explicitly.

    REVIEWS-130
    Tom Scott



Workarea Reviews 3.0.1 (2018-06-12)
--------------------------------------------------------------------------------

*   Translate hard-coded text on new review form

    - Add `workarea.storefront.reviews.hints.display_name` for viewing hint on
    how names are displayed.
    - Add `workarea.storefront.reviews.hints.email` for viewing hint on how
    email is used.

    REVIEWS-130
    Tom Scott



Workarea Reviews 3.0.0 (2018-05-24)
--------------------------------------------------------------------------------

*   Add calculated review fields on product to data file ignore fields

    REVIEWS-129
    Matt Duffy

*   Cancel review requests after user reviews a product from order

    If a user reviews a product, either through a review request email or
    directly on the site, other future review requests are canceled for
    orders with that product.

    REVIEWS-128
    Matt Duffy

*   Add administrable content to review request emails

    REVIEWS-128
    Matt Duffy

*   set verified on a sample of review seeds

    Matt Duffy

*   Add importing/exporting from v3.3

    ECOMMERCE-6010
    Ben Crouse

*   Remove import, update to work with base DataFile and bulk action changes

    REVIEWS-127
    Matt Duffy

*   Leverage Workarea Changelog task

    ECOMMERCE-5355
    Curt Howard

*   Update Mailers for Premailer

    REVIEWS-126
    Curt Howard

*   Fix CHANGELOG

    Curt Howard

*   Update status report mailer partial to fit with new templates

    Matt Duffy

*   Update review request template

    Matt Duffy

*   Fix issues around reviews of missing products

    Matt Duffy

*   Update review import to align with Workarea::Import changes

    REVIEWS-124
    Matt Duffy

*   Add verified facet and column to reviews

    REVIEWS-116
    Matt Duffy

*   Add reviews import to admin

    REVIEWS-107
    Matt Duffy

*   Automatically configure recaptcha for test and development

    REVIEWS-117
    Matt Duffy

*   Disable submit button when user leaves a review

    - This prevents multiple review submissions, which can happen even with recaptcha in place

    REVIEWS-119
    Dave Barnow

*   Mark requests as sent after sending email

    Matt Duffy

*   Improve write a review form

    * Remove fieldset and use property/label instead
    * Use inline-list for rating stars wrapper
    * Mark optional fields as such
    * Use a grid for submit/cancel buttons for modal action consistency
    * Use email_field_tag with correct attributes

    REVIEWS-113
    Dave Barnow

*   Clean up navigation links

    * Add link to marketing dashboard
    * Fix link to point back to marketing dashboard
    * Add jump to navigation

    REVIEWS-115
    Dave Barnow

*   Send review request emails to users who have recently placed an order

    REVIEWS-110
    Matt Duffy

*   Removes appended stylesheet for product_summary

    REVIEWS-59
    Mansi Pathak

*   Removes .rating styles extended in product_summary sass

    REVIEWS-59
    Mansi Pathak

*   Mark reviews made by users who have purchased the product as verified

    REVIEWS-108
    Matt Duffy

*   Allow reviews without logging in. Loosen model validations

    REVIEWS-112
    Matt Duffy

*   Cleans up sass to match code standards

    * add functional vars

    * extend trumps and objects

    * resolve sass linter warnings

    * use spacing unit for marign and padding

    REVIEWS-98
    Mansi Pathak

*   Add summary of reviews to status report email

    REVIEWS-109
    Matt Duffy

*   Convert index from summaries to table

    REVIEWS-103
    Curt Howard



Workarea Reviews 2.1.1 (2018-04-03)
--------------------------------------------------------------------------------

*   Default Reviews link in Product Auxiliary Nav to sort by newest

    REVIEWS-121
    Dave Barnow

Workarea Reviews 2.1.0 (2017-09-15)
--------------------------------------------------------------------------------

*   Adds conditional to show how many pending reviews compared to all reviews

    REVIEWS-91
    Ivana Veliskova

*   Fix 0 Reviews State on PDP

    * Shows the user there are no reviews
    * lines review count display and write a review in the same row
    ** allows for consistent ui across items with reviews and items without reviews

    REVIEWS-90
    Lucas Boyd

*   Fix Review Stars UI in ie11

    Add a width to write review stars to prevent them from spreading too far apart and breaking the UI

    REVIEWS-96
    Lucas Boyd

*   Replace modernizr with feature js in CSS

    Replaces modernizr selectors with the corresponding featurejs selectors

    REVIEWS-94
    Lucas Boyd

*   Update activity with correct workarea helper for restore links

    REVIEWS-95
    Matt Duffy

*   Add restore link to reviews for admin trash

    REVIEWS-95
    Matt Duffy


Workarea Reviews 2.0.5 (2017-08-22)
--------------------------------------------------------------------------------

*   Adds conditional to show how many pending reviews compared to all reviews

    REVIEWS-91
    Ivana Veliskova

*   Fix 0 Reviews State on PDP

    * Shows the user there are no reviews
    * lines review count display and write a review in the same row
    ** allows for consistent ui across items with reviews and items without reviews

    REVIEWS-90
    Lucas Boyd

*   Fix Review Stars UI in ie11

    Add a width to write review stars to prevent them from spreading too far apart and breaking the UI

    REVIEWS-96
    Lucas Boyd

*   Replace modernizr with feature js in CSS

    Replaces modernizr selectors with the corresponding featurejs selectors

    REVIEWS-94
    Lucas Boyd


Workarea Reviews 2.0.4 (2017-07-07)
--------------------------------------------------------------------------------

*   Wrap product ID in quotes for more relevant search results

    REVIEWS-92
    Dave Barnow

*   Reset review attributes to defaults for product copies

    REVIEWS-89
    Matt Duffy


Workarea Reviews 2.0.3 (2017-06-08)
--------------------------------------------------------------------------------

*   Fix test to match change to class

    The interface of storefront/product changed but the test wasn't changed
    to match it.  Change the test to check if #sorts includes the sorting
    rating.

    no changelog

    REVIEWS-88
    Eric Pigeon

*   Correct storefront product sorting by top rated, clean up admin reviews sorting

    REVIEWS-83
    Matt Duffy

*   Expose top rated sort option to review admin. Fix issues with review sorting

    REVIEWS-83
    Matt Duffy

*   Rename admin review view model to fit expected naming convention for search results

    REVIEWS-82
    Matt Duffy

*   Remove jshint and replace with eslint

    REVIEWS-81
    Dave Barnow


Workarea Reviews 2.0.2 (2017-05-26)
--------------------------------------------------------------------------------

*   Append seeds after others so that all product types are accounted for

    REVIEWS-80
    Dave Barnow

*   Don't load helper in initialiser

    This was causing a rails error when the plugin is installed in the same app as package-products.

    REVIEWS-78
    Beresford, Jake


Workarea Reviews 2.0.1 (2017-05-19)
--------------------------------------------------------------------------------


Workarea Reviews 2.0.0 (2017-05-17)
--------------------------------------------------------------------------------

*   Simplify admin reviews UI

    REVIEWS-69
    Matt Duffy

*   Upgrade Reviews for v3

    REVIEWS-69
    Eric Pigeon

*   Reviews upgrade for v3 Frontend work

    * Updated remaining admin translations
    * Make the UI all nice and that.
    * Updated admin views (summary card, edit etc.)
    * Change review stars implementation to use inline svgs
    * Update write review form star buttons to work with inline_svg

    REVIEWS-69
    Beresford, Jake

*   Upgrade Reviews for v3

    REVIEWS-69
    Eric Pigeon


WebLinc Reviews 1.1.0 (2016-10-12)
--------------------------------------------------------------------------------

*   Add activity support for v2.3

    REVIEWS-66
    Ben Crouse

*   Improve ajax submit review feature

    REVIEWS-64
    Curt Howard

*   Fix malformed link to reviews section on PDP

    REVIEWS-62
    Curt Howard

*   Add teaspoon test for ajax submit reviews

    REVIEWS-56
    Kristen Ward

*   Set up teaspoon in reviews gem

    Add necessary files and settings

    REVIEWS-56
    Kristen Ward

*   Submit reviews via ajax when submitted from dialog

    Allow the 'write review' form to be opened in a dialog
    and submitted via ajax to keep the user on the same page.

    REVIEWS-56
    Kristen Ward

*   Correct the ordering of reviews on PDP to be based on created_at field.

    REVIEWS-60
    gharnly

*   Correct the ordering of reviews on PDP to be based on created_at field.

    REVIEWS-60
    gharnly

*   Force loading of the sort decorator before the product browse decorator

    Because decorator-loading order isn't deterministic, sometimes the product browse decorator gets loaded first. This causes an error because it tries to reference a method added in the sort decorator.

    REVIEWS-57
    Ben Crouse

*   Force loading of the sort decorator before the product browse decorator

    Because decorator-loading order isn't deterministic, sometimes the product browse decorator gets loaded first. This causes an error because it tries to reference a method added in the sort decorator.

    REVIEWS-57
    Ben Crouse

*   Add hidden-field honeypot for review bots.

    Adds a `username` field on the new review form which is hidden with CSS.
    If this field is present on submission we drop the request and redirect
    as if it were successfully created.

    REVIEWS-53
    Thomas Vendetta

*   Better logic and test

    REVIEWS-54
    Thomas Vendetta

*   Merge branch 'feature/REVIEWS-54-require-users-spend-money-to-post-reviews' of ssh://stash.tools.workarea.com:7999/wl/workarea-reviews into feature/REVIEWS-54-require-users-spend-money-to-post-reviews
    Thomas Vendetta

*   Add visually hidden class to field

    REVIEWS-53
    Thomas Vendetta

*   Config to require user spend money to post reviews

    Adds a configuration setting that requires users to have spent money
    to post a product review.

    REVIEWS-54
    Thomas Vendetta

*   Add hidden-field honeypot for review bots.

    Adds a `username` field on the new review form which is hidden with CSS.
    If this field is present on submission we drop the request and redirect
    as if it were successfully created.

    REVIEWS-53
    Thomas Vendetta

*   Fix read/write review scroll_to_button bug

    The `anchor` param being passed to some route helpers was being
    improperly merged into the options hash. This commit separates this
    param from the other options passed to the helper.

    REVIEWS-52
    Curt Howard


WebLinc Reviews 1.0.5 (2016-08-30)
--------------------------------------------------------------------------------

*   Fix malformed link to reviews section on PDP

    REVIEWS-62
    Curt Howard


WebLinc Reviews 1.0.4 (2016-05-09)
--------------------------------------------------------------------------------

*   Correct the ordering of reviews on PDP to be based on created_at field.

    REVIEWS-60
    gharnly


WebLinc Reviews 1.0.3 (2016-04-08)
--------------------------------------------------------------------------------

*   Force loading of the sort decorator before the product browse decorator

    Because decorator-loading order isn't deterministic, sometimes the product browse decorator gets loaded first. This causes an error because it tries to reference a method added in the sort decorator.

    REVIEWS-57
    Ben Crouse


WebLinc Reviews 1.0.2 (2016-04-05)
--------------------------------------------------------------------------------


WebLinc Reviews 1.0.1 (January 26, 2016)
--------------------------------------------------------------------------------

*   Fix read/write review scroll_to_button bug

    The `anchor` param being passed to some route helpers was being
    improperly merged into the options hash. This commit separates this
    param from the other options passed to the helper.

    REVIEWS-52


Unreleased
--------------------------------------------------------------------------------

*   Config to require user spend money to post reviews

    Adds a configuration setting that requires users to have spent money
    to post a product review.

    REVIEWS-54

*   Add hidden-field honeypot for review bots.

    Adds a `username` field on the new review form which is hidden with CSS.
    If this field is present on submission we drop the request and redirect
    as if it were successfully created.

    REVIEWS-53


WebLinc Reviews 1.0.0 (January 13, 2016)
--------------------------------------------------------------------------------

*   Update for compatibility with WebLinc 2.0

*   Replace absolute URLs with relative paths


WebLinc Reviews 0.10.0 (October 7, 2015)
--------------------------------------------------------------------------------

*   Add metadata and update context-menu

    REVIEWS-50

*   Update plugin to be compatible with v0.12

    Update new & edit views, property work
    Add blank row to permissions partial
    Update indexes, add context-menu to summary/edit

    REVIEWS-50

*   Update menu for compatibility with ECOMMERCE-1344

    REVIEWS-45

*   Fix presentation of dashboard pending reviews count

    Fix markup within dashboard to do list partial to match the to do list
    markup from workarea.

    REVIEWS-51

*   Update sort by property js template with correct class name

    REVIEWS-46


WebLinc Reviews 0.9.0 (August 21, 2015)
--------------------------------------------------------------------------------

*   Allow reviews without a user so that reviews from legacy applications can
    be imported.

    REVIEWS-44

    826ca2a5c96062bc4e0be5adb2887baec76effbd
    3b578531e3a3d23d292cffb592a3a53b2c63e42b

*   Rename SCSS blocks `panel` and `panel--buttons` to `index-filters` and
    `form-actions`, respectively, for compatibility with WebLinc 0.11.

    REVIEWS-43

    c2a5cbfd09014160afe7ed5039f60ce229e4f096

*   Use vector images for review stars. Re-write display code accordingly.

    REVIEWS-34

    491e6bad575c921e5e6f57f4962b45f4672c18db (merge)


WebLinc Reviews 0.8.0 (July 12, 2015)
--------------------------------------------------------------------------------

*   Add model summaries to Admin indexes.

    REVIEWS-39

    d462476e7bd817f505c703c7cf7daa66874e7da3
    410b6dd1f2590178860421784a9adec0a4520c4d
    1f52be2a94898d03639b82a0bdeafde146b564d6
    bd21b18c9c65fa6a9010098f63ed877f1ce65389

*   Update for compatibility with workarea 0.10 and constrain to workarea 0.10.

    eaa21d516260b6bdd20cffdfdf6f260a314e80c6
    e641252d86ac34cecb696a992cec2976514a2946
    b0a1b40cb10f10dd7b287331d2ef5c0584544dcd
    5606d9fe4eac382d120266b79bfdf0fcbfc18953
    7d251907578264886982393b821056f614d8c87c
    170ba9bdaf8aa60cd47d4a0030e20048e3c347f6
    5babadcb3270b4d6c2f06e9fd68efe3ad6fdf35b
    dd669d4b31f0f20ff51b100a57274e2d39ef897e

*   Fix "back" links in Admin.

    REVIEWS-41

    696b1698c97cc08915588db304a67a931ee57a0b


WebLinc Reviews 0.7.0 (June 1, 2015)
--------------------------------------------------------------------------------

*   Rename fixtures to factories and clean up factories.

*   Update for compatibility and consistency with workarea 0.9.0.

*   Remove pagination from reviews in Store Front. Display all reviews.

    REVIEWS-20


WebLinc Reviews 0.6.0 (April 10, 2015)
--------------------------------------------------------------------------------

*   Update JavaScript modules for compatibility with WebLinc 0.8.0.

*   Update testing environment for compatibility with WebLinc 0.8.0.

*   Use new decorator style for consistency with WebLinc 0.8.0.

*   Remove gems server secrets for consistency with WebLinc 0.8.0.

*   Update assets for compatibility with WebLinc 0.8.0.
