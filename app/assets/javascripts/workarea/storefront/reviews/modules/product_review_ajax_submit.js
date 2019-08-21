/**
 * @namespace WORKAREA.productReviewAjaxSubmit
 */
WORKAREA.registerModule('productReviewAjaxSubmit', (function () {
    'use strict';

    var submitForm = function ($form, event) {
            if ($form.valid() === false) { return; }

            event.preventDefault();

            $.ajax({
                url: $form.attr('action'),
                type: $form.attr('method'),
                data: $form.serialize()
            }).done(_.partial(WORKAREA.dialog.closeClosest, $form));
        },

        formNotInDialog = function ($form) {
            return _.isEmpty($form.closest('.ui-dialog'));
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.productReviewAjaxSubmit
         */
        init = function ($scope) {
            var $form = $('[data-product-review-ajax-submit]', $scope);

            if (formNotInDialog($form)) { return; }

            $form.on('submit', _.partial(submitForm, $form));
        };

    return {
        init: init
    };
}()));
