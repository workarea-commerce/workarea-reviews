//= require workarea/core/config
//
(function () {
    'use strict';

    describe('WORKAREA.productReviewAjaxSubmit', function () {
        describe('init', function () {
            var formIsInDialog = function ($form) {
                    return ! _.isEmpty(WORKAREA.dialog.closest($form));
                };

            beforeEach(function () {
                this.fixtures = fixture.load('product_review_ajax_submit.html');

                WORKAREA.dialog.create($(this.fixtures));
                WORKAREA.productReviewAjaxSubmit.init($(this.fixtures));
            });

            it('dialog remains if form invalid', function () {
                expect($('form').valid()).to.equal(false);

                $('form').trigger('submit');

                expect(formIsInDialog($('form'))).to.equal(true);
            });
        });
    });
}());
