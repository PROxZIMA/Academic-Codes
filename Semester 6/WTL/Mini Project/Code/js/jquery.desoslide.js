/*!
* Version 1.2.3.1
* jQuery: desoSlide plugin - jquery.desoslide.js
* Copyright - 2013 - https://github.com/sylouuu/desoslide
* This source code is under the MIT License
*/

/*jslint browser: true, devel: true, eqeq: true, plusplus: true, unparam: true, vars: true, white: true */
/*global $, jQuery*/
(function($) {

    'use strict';

    $.fn.desoSlide = function(options) {

        /**
        * Default values
        */
        var defaults = {
            main: {
                container:  false,      /* Container for the main image */
                cssClass:   '',         /* Main image class */
                insertion:  'append'    /* Wrapper insertion type ("prepend", "append", "replace") */
            },
            auto: {
                load:       true,       /* Preloading images */
                start:      false       /* Autostarting diaporama */
            },
            first:          0,          /* Index of the first image to show */
            interval:       3000,       /* Interval between each image */
            effect:         'fade',     /* Transition effect ("fade", "flip", "light", "roll", "rotate") */
            overlay:        'always',   /* How to show overlay ("always", "hover", "none") */
            caption:        false,      /* Show caption: data-desoslide-caption attribute required */
            controls: {
                enable:     true,       /* Able to control by clicking (prev/pause/play/next) */
                keys:       true        /* Able to control by using the keyboard shortcuts (left/right/space) */
            },
            events: {
                thumbClick: false,      /* On thumb click */
                prev:       false,      /* On previous */
                pause:      false,      /* On pause */
                play:       false,      /* On play */
                next:       false,      /* On next */
                completed:  false       /* The slider result ("success", "error", "warning") */
            }
        };

        /**
        * Extend options
        */
        var p = $.extend(true, {}, defaults, options);

        /**
        * Delay
        */
        var delay = (function() {
            var timer = 0;
            return function(callback, ms){
                clearTimeout(timer);
                timer = setTimeout(callback, ms);
            };
        }());

        /**
        * Working variables
        */
        var
            $thumbs_container = this,
            $thumbs = $thumbs_container.find('li'),
            total_thumbs = $thumbs.length,
            current_img = p.first,
            img_to_show,
            $overlay = $(p.main.container).find('.desoSlide-overlay'),
            ms = (p.interval < 1500) ? 1500 : p.interval,
            timer = false,
            alt,
            caption,
            href,
            $controls_wrapper,
            effects,
            $spinner,
            first_error = false;



        /**
        * Main object
        */
        var app = {

            /**
            * Function that checks the configuration
            */
            checks: function() {
                /**
                * If the container does not exist
                */
                if(!$thumbs_container.length) {
                    app.resultHandler('error', $thumbs_container.selector +' doesn\'t exist.');
                }

                /**
                * main.container option checks
                */
                if(!p.main.container) {
                    app.resultHandler('error', 'You must specify the "main.container" option. Check out the documentation.');
                } else {
                    /**
                    * If the container does not exist
                    */
                    if(!$(p.main.container).length) {
                        app.resultHandler('error', $(p.main.container).selector +' doesn\'t exist.');
                    }
                }

                /**
                * Accepted overlay values
                */
                var overlay_values = ['always', 'hover', 'none'];

                /**
                * overlay option checker
                */
                if(overlay_values.indexOf(p.overlay) === -1) {
                    app.resultHandler('error', 'Incorrect value for the "overlay" option. Check out the documentation.');
                }

                if(current_img >= total_thumbs) {
                    if(total_thumbs === 0) {
                        app.resultHandler('error', 'You must have at least 1 thumbnail.');
                    } else {
                        app.resultHandler('error', 'The "first" option must be between 0 and '+ (total_thumbs - 1) +'.');
                    }
                }
            },

            /**
            * Function that checks the markup
            */
            checkData: function() {
                /**
                * Captions checks
                */
                if(p.caption && (caption === undefined || caption === '')) {
                    app.resultHandler('warning', 'The captions are enabled and the data-desoslide-caption attribute is missing on a thumb. Add it or disable captions. Check out the documention.');
                }

                /**
                * W3C check
                */
                if(alt === undefined || alt === '') {
                    app.resultHandler('warning', 'The alt attribute is missing on a thumb, it\'s mandatory on <img> tags.');
                }
            },

            /**
            * Function that initiliazes the plugin
            */
            init: function() {
                /**
                * Basic checks
                */
                app.checks();

                /**
                * Autoloading images
                */
                app.loadImages();

                /**
                * Handling transition effect
                */
                app.effectHandler();

                /**
                * Adding wraper
                */
                app.addWrapper();

                /**
                * Showing main image
                */
                app.displayImg();

                /**
                * Bindings events
                */
                app.events();
            },

            /**
            * Function that loads images
            */
            loadImages: function() {
                if(p.auto.load) {
                    $thumbs.find('a').each(function(i, item) {
                        $('<img>', {
                            src: item.href,
                            alt: ''
                        }).hide().appendTo('body');
                    });
                }
            },

            /**
            * Function that handles the effect
            */
            effectHandler: function() {
                /**
                * Available effects with in/out matches
                */
                effects = {
                    'fade': { /* Default */
                        'in': 'fadeIn',
                        'out': 'fadeOut'
                    },
                    'sideFade': {
                        'in': 'fadeInLeft',
                        'out': 'fadeOutRight'
                    },
                    'sideFadeBig': {
                        'in': 'fadeInLeftBig',
                        'out': 'fadeOutRightBig'
                    },
                    'flip': {
                        'in': 'flipInX',
                        'out': 'flipOutX'
                    },
                    'light': {
                        'in': 'lightSpeedIn',
                        'out': 'lightSpeedOut'
                    },
                    'roll': {
                        'in': 'rollIn',
                        'out': 'rollOut'
                    },
                    'rotate': {
                        'in': 'rotateIn',
                        'out': 'rotateOut'
                    }
                };

                /**
                * Incorrect effect value
                */
                if(!effects.hasOwnProperty(p.effect)) {
                    /**
                    * Get the default effect
                    */
                    p.effect = defaults.effect;

                    app.resultHandler('error', 'Incorrect value for the "effect" option. Default value is used. Check out the documentation.');
                }

            },

            /**
            * Function that makes the out image effect
            */
            outEffect: function() {
                /**
                * Hiding the old one
                */
                $(p.main.container).find('img').removeClass('animated '+ effects[p.effect].in).addClass('animated '+ effects[p.effect].out);

                /**
                * Showing the new one
                */
                setTimeout(function() {
                    app.displayImg();
                }, 900);
            },

            /**
            * Function that adds the wrapper
            */
            addWrapper: function() {
                /**
                * The wrapper tag
                */
                var $wrapper = $('<div>', {
                    'class': 'desoSlide-wrapper'
                });

                /**
                * The img tag
                */
                var $img = $('<img>').addClass(p.main.cssClass).css('opacity', 0);

                /**
                * DOM insertion
                */
                switch(p.main.insertion) {
                    case 'prepend':
                        $img.prependTo($(p.main.container)).wrap($wrapper);
                    break;
                    case 'append':
                        $img.appendTo($(p.main.container)).wrap($wrapper);
                    break;
                    case 'replace':
                        $(p.main.container).html($img).wrapInner($wrapper);
                    break;
                    default:
                        app.resultHandler('error', 'Incorrect value for the "insertion" option. Check out the documentation.');
                    break;
                }
            },

            /**
            * Function that adds the spinner
            */
            addSpinner: function() {
                /**
                * The spinner
                */
                $spinner = $('<div>').addClass('desoSlide-spinner');

                /**
                * Adding
                */
                $(p.main.container).css('text-align', 'center').prepend($spinner);
            },

            /**
            * Function that removes the spinner
            */
            removeSpinner: function() {
                if($spinner.length) {
                    $spinner.remove();
                }
            },

            /**
            * Function that displays the new image
            */
            displayImg: function() {
                /**
                * Callback
                */
                app.resultHandler();

                img_to_show = 0;

                /**
                * Count reset
                */
                if(current_img < 0){
                    current_img = total_thumbs - 1;
                }

                /**
                * Count reset
                */
                if(current_img >= total_thumbs) {
                    current_img = 0;
                }

                /**
                * Next image
                */
                img_to_show = current_img;

                /**
                * Data
                */
                var src     = $thumbs.find('a').eq(img_to_show).attr('href');
                alt     = $thumbs.find('img').eq(img_to_show).attr('alt');
                caption = $thumbs.find('img').eq(img_to_show).data('desoslide-caption');
                href    = $thumbs.find('img').eq(img_to_show).data('desoslide-href');

                /**
                * Checking the data
                */
                app.checkData();

                $(p.main.container).find('img').attr({
                    'src': src,
                    'alt': alt,
                    'data-desoslide-caption': caption
                }).one('load', function() {
                    /**
                    * Showing
                    */
                    $(this).removeClass('animated '+ effects[p.effect].out).addClass('animated '+ effects[p.effect].in)
                        /**
                        * Animation done
                        */
                        .one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                            /**
                            * Adding overlay
                            */
                            app.addOverlay();
                    });

                    /**
                    * Starting the loop
                    */
                    if(p.auto.start) {
                        current_img++;

                        timer = setTimeout(function() {
                            app.outEffect();
                        }, ms);
                    }
                });
            },

            /**
            * Function that adjusts the overlay position
            */
            addOverlay: function() {
                if(p.overlay !== 'none') {
                    if(p.caption || p.controls.enable) {
                        /**
                        * Main image position
                        */
                        var
                            pos = $(p.main.container).find('img').position(),
                            border = parseInt($(p.main.container).find('img').css('border-left-width'), 10);

                        /**
                        * Main image height
                        */
                        var
                            width_plus_border = $(p.main.container).find('img').width() + border,
                            height_plus_border = $(p.main.container).find('img').height() + border;

                        if($(p.main.container).find('.desoSlide-overlay').length === 0) {
                            $('<div>', {
                                'class': 'desoSlide-overlay'
                            }).appendTo($(p.main.container).find('.desoSlide-wrapper'));
                        }

                        $overlay = $(p.main.container).find('.desoSlide-overlay');

                        /**
                        * Calculate new height with paddings
                        */
                        var
                            paddingTop = parseInt($overlay.css('padding-top').replace('px', ''), 10),
                            paddingBottom = parseInt($overlay.css('padding-bottom').replace('px', ''), 10),
                            paddingLeft = parseInt($overlay.css('padding-left').replace('px', ''), 10),
                            paddingRight = parseInt($overlay.css('padding-right').replace('px', ''), 10);

                        var overlayHeight = parseInt($overlay.css('height').replace('px', ''), 10) - (paddingLeft + paddingRight);
                        overlayHeight = (parseInt(height_plus_border, 10) - overlayHeight - (paddingTop + paddingBottom));

                        var
                            top = pos.top + overlayHeight,
                            left = pos.left;

                        /**
                        * Update the overlay position
                        */
                        $overlay.css({
                            'left':     left +'px',
                            'top':      top +'px',
                            'width':    width_plus_border +'px'
                        });

                        /**
                        * Showing the overlay if needed
                        */
                        if(p.overlay === 'always') {
                            $overlay.animate({
                                opacity: 0.7
                            }, 500);
                        }

                        /**
                        * Add caption
                        */
                        if(p.caption) {
                            app.updateCaption();
                            app.addLink();
                        }

                    } else {
                        app.addLink();
                    }

                    /**
                    * Add controls
                    */
                    if(p.controls.enable) {
                        app.addControls();
                    }
                }
            },

            /**
            * Function that updates the caption
            */
            updateCaption: function() {
                $overlay.html(caption);
            },

            /**
            * Function that adds the link on the main image & caption
            */
            addLink: function() {
                var anchor_exists = ($(p.main.container).find('a.desoslide-link').length > 0) ? true : false;
                var href_exists = (href !== undefined && href !== '') ? true : false;

                /**
                * The link tag
                */
                var $a = $('<a>', {
                    'class':    'desoslide-link',
                    'href':     href,
                    'target':   '_blank'
                });

                if(anchor_exists && href_exists) {
                    /**
                    * Updating the href
                    */
                    $(p.main.container).find('a.desoslide-link').attr('href', href);
                } else {
                    if(anchor_exists && !href_exists) {
                        /**
                        * Replacing the <a> tag with this content
                        */
                        $(p.main.container).find('a.desoslide-link').replaceWith($a);
                    } else {
                        if(!anchor_exists && href_exists) {
                            /**
                            * Adding the link tag
                            */
                            $(p.main.container).find('.desoSlide-wrapper').append($a);
                        }
                    }
                }

            },

            /**
            * Function that adds the controls
            */
            addControls: function() {
                $(p.main.container).find('.desoSlide-controls-wrapper').remove();

                /**
                * Controls buttons
                */
                var $prev   = '<a href="#prev"><span class="desoSlide-controls prev"></span></a>';
                var $pause  = '<a href="#pause"><span class="desoSlide-controls pause"></span></a>';
                var $play   = '<a href="#play"><span class="desoSlide-controls play"></span></a>';
                var $next   = '<a href="#next"><span class="desoSlide-controls next"></span></a>';

                /**
                * The wrapper
                */
                var $controls = $('<div>', {
                    'class': 'desoSlide-controls-wrapper'
                }).append($prev + $pause + $play + $next);

                /**
                * Dynamic positioning
                */
                $controls.css({
                    'width': $overlay.css('width'),
                    'left': $overlay.css('left')
                });

                /**
                * Adding the controls wrapper
                */
                if($(p.main.container).find('a.desoslide-link').length > 0) {
                    $controls.appendTo($(p.main.container).find('a.desoslide-link'));
                } else {
                    $controls.appendTo($(p.main.container).find('.desoSlide-wrapper'));
                }

                $controls_wrapper = $(p.main.container).find('.desoSlide-controls-wrapper');

                if($controls_wrapper.length) {
                    /**
                    * Triggering "play" if autostart
                    */
                    if(p.auto.start) {
                        $controls_wrapper.find('a[href="#play"]').hide().parent().find('a[href="#pause"]').show();
                    } else {
                        $controls_wrapper.find('a[href="#pause"]').hide().parent().find('a[href="#play"]').show();
                    }
                }
            },

            /**
            * Function that pauses the diaporama
            */
            pause: function() {
                if(p.auto.start && timer) {
                    p.auto.start = false;

                    clearTimeout(timer);
                    current_img--;

                    if($controls_wrapper) {
                        $controls_wrapper.find('a[href="#pause"]').hide().parent().find('a[href="#play"]').show();
                    }
                }
            },

            /**
            * Function that plays the diaporama
            */
            play: function() {
                if(!p.auto.start) {
                    p.auto.start = true;

                    if(img_to_show === current_img) {
                        current_img++;
                    }

                    app.outEffect();

                    if($controls_wrapper) {
                        $controls_wrapper.find('a[href="#play"]').hide().parent().find('a[href="#pause"]').show();
                    }
                }
            },

            /**
            * Function that handles the plugin "result"
            *
            * @param string type
            * @param string msg
            */
            resultHandler: function(type, msg) {
                /**
                * It's not the first error
                */
                if(!first_error) {
                    /**
                    * Depending on the result
                    */
                    switch(type) {
                        case 'error':
                            /**
                            * Logging
                            */
                            if(console !== undefined) {
                                console.error('desoSlide: '+ msg);
                            }

                            if(p.events.completed) {
                                p.events.completed('error');
                            }

                            first_error = type;
                        break;
                        case 'warning':
                            /**
                            * Logging
                            */ 
                            if(p.events.completed) {
                                p.events.completed('warning');
                            }
                        break;
                        default:
                            if(p.events.completed) {
                                p.events.completed('success');
                            }
                        break;
                    }
                }
            },

            /**
            * Function that handles the plugin events
            */
            events: function() {

                /**
                * Clicking on thumbnail
                */
                $thumbs.find('a').on('click', function(e) {
                    e.preventDefault();
                    var $this = $(this),
                    index = $this.parent('li').index();

                    /**
                    * If the clicked image is not already displayed
                    */
                    if(index !== current_img) {
                        /**
                        * Hiding the overlay
                        */
                        $overlay.animate({ opacity: 0 });

                        /**
                        * Setting the current image index
                        */
                        current_img = index;

                        /**
                        * Calling the displayer
                        */
                        app.outEffect();

                        /**
                        * Pausing
                        */
                        app.pause();
                    }

                    /**
                    * Callback
                    */
                    if(p.events.thumbClick) {
                        p.events.thumbClick();
                    }
                });

                /**
                * Hover on thumb
                */
                $thumbs.find('img').on({
                    mouseover: function() {
                        $(this).stop(true, true).animate({
                            opacity: 0.7
                        }, 'normal');
                    },
                    mouseout: function() {
                        $(this).stop(true, true).animate({
                            opacity: 1
                        }, 'fast');
                    }
                });

                /**
                * Hover on overlay
                */
                if(p.overlay === 'hover') {
                    $(p.main.container).on({
                        mouseover: function() {
                            $overlay.stop().animate({
                                opacity: 0.7
                            }, 400);
                        },
                        mouseleave: function() {
                            $overlay.stop().animate({
                                opacity: 0
                            }, 400);
                        }
                    });
                }

                if(p.controls.enable && p.controls.keys) {
                    /**
                    * Keys binder
                    */
                    $(document).on('keydown', function(e){
                        switch(e.which) {
                            case 37: /* Left arrow */
                                $(p.main.container).trigger('prev.desoslide');
                            break;
                            case 39: /* Right arrow */
                                $(p.main.container).trigger('next.desoslide');
                            break;
                            case 32: /* Space */
                                e.preventDefault();
                                $(p.main.container).trigger((!p.auto.start) ? 'play' : 'pause' +'.desoslide');
                            break;
                        }
                    });
                }

                /**
                * Click on control
                */
                $(p.main.container).on('click', '.desoSlide-controls-wrapper a', $(p.main.container), function(e) {
                    e.preventDefault();

                    switch($(this).attr('href')) {
                        case '#prev':
                            $(p.main.container).trigger('prev.desoslide');
                        break;
                        case '#pause':
                            $(p.main.container).trigger('pause.desoslide');
                        break;
                        case '#play':
                            $(p.main.container).trigger('play.desoslide');
                        break;
                        case '#next':
                            $(p.main.container).trigger('next.desoslide');
                        break;
                    }
                });

                /**
                * On previous
                */
                $(p.main.container).on('prev.desoslide', function() {
                    /**
                    * Pausing
                    */
                    app.pause();

                    /**
                    * Previous image
                    */
                    current_img--;

                    /**
                    * Applying the out effect
                    */
                    app.outEffect();

                    /**
                    * Callback
                    */
                    if(p.events.prev) {
                        p.events.prev();
                    }
                });

                /**
                * On pause
                */
                $(p.main.container).on('pause.desoslide', function() {
                    /**
                    * Pausing
                    */
                    app.pause();

                    /**
                    * Callback
                    */
                    if(p.events.pause) {
                        p.events.pause();
                    }
                });

                /**
                * On play
                */
                $(p.main.container).on('play.desoslide', function() {
                    /**
                    * Playing
                    */
                    app.play();

                    /**
                    * Callback
                    */
                    if(p.events.play) {
                        p.events.play();
                    }
                });

                /**
                * On next
                */
                $(p.main.container).on('next.desoslide', function() {
                    /**
                    * Pausing
                    */
                    app.pause();

                    /**
                    * Next image
                    */
                    current_img++;

                    /**
                    * Applying the out effect
                    */
                    app.outEffect();

                    /**
                    * Callback
                    */
                    if(p.events.next) {
                        p.events.next();
                    }
                });

                /**
                * New overlay position when resizing
                */
                if(p.overlay !== 'none') {
                    $(window).bind('resize', function() {
                        delay(function() {
                            app.addOverlay();
                        }, 100);
                    });
                }
            }

        };

        /**
        * Adding spinner
        */
        app.addSpinner();

        /**
        * All images are loaded
        */
        $(window).load(function() {
            /**
            * Removing spinner
            */
            app.removeSpinner();

            /**
            * Initializing
            */
            app.init();
        });

        /**
        * Preserving chainability
        */
        return this;
    };
}(jQuery));
