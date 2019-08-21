/**
 * @namespace WORKAREA.ratingButtons
 */
WORKAREA.registerModule('ratingButtons', (function () {
    'use strict';

    var activateLabels = function (radioButton, originalIndex, $scope) {
            var $allButtons = getAllRatingButtons($(document)),

                updateState = function (index, button) {
                    var $label = getAssociatedLabel(button, $scope);

                    $label.removeClass('write-review__star--hovered write-review__star--active');

                    if ($label.data('index') <= originalIndex) {
                        $label.addClass('write-review__star--active');
                    }
                };

            if ($(radioButton).is(':checked')) {
                $allButtons.each(updateState);
            }
        },

        getAllRatingButtons = function ($scope) {
            return $('[data-rating-button]', $scope);
        },

        getAssociatedLabel = function (button, $scope) {
            return $('label[for=' + $(button).attr('id') + ']', $scope);
        },

        removeHoverClass = function ($label) {
            $label.removeClass('write-review__star--hovered');
        },

        addHoverClass = function ($label) {
            $label.addClass('write-review__star--hovered');
        },

        removeHoverStateFromLabel = function ($scope) {
            var $buttons = getAllRatingButtons($scope),

                removeState = function (index, button) {
                    var $label = getAssociatedLabel(button, $scope);

                    removeHoverClass($label);
                };

            $buttons.each(removeState);
        },

        addHoverStateToLabels = function ($scope, originalIndex) {
            var $buttons = getAllRatingButtons($scope),

                addState = function (index, button) {
                    var $label = getAssociatedLabel(button, $scope);

                    if ($label.data('index') <= originalIndex) {
                        addHoverClass($label);
                    }
                };

            $buttons.each(addState);
        },

        setupLabels = function ($scope, index, button) {
                var $label = getAssociatedLabel(button, $scope),
                    labelTitle = $('.write-review__star-text', $label).text();

                /**
                 * 1. per http://www.workarea.com/labs/touching-on-html-labels/
                 */

                $label
                .attr('title', labelTitle)
                .data('index', index)
                .on('click', $.noop) /* [1] */
                .on('mouseenter', _.partial(addHoverStateToLabels, $scope, index))
                .on('mouseleave', _.partial(removeHoverStateFromLabel, $scope));

                activateLabels(button, index, $scope);

                $(button)
                .on('click', _.partial(activateLabels, button, index, $scope))
                .on('focus', _.partial(addHoverClass, $label))
                .on('blur', _.partial(removeHoverClass, $label));
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.ratingButtons
         */
        init = function ($scope) {
            $('[data-rating-button]', $scope)
            .each(_.partial(setupLabels, $scope));
        };

    return {
        init: init
    };
}()));
