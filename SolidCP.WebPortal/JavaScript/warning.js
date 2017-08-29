var pjQuery = jQuery.noConflict(true);
(function($) {
    $(document).ready(function() {
        var isIE10 = false;
        /*@cc_on
        if (/^10/.test(@_jscript_version)) {
            isIE10 = true;
        }
        @*/
        if (isIE10) {
            $('div.FormBody')
            .before(
                $('<div/>')
                .addClass('MessageBox Yellow')
                .append('Attention Internet Explorer 10 users!<br/>')
                .append(
                    $('<span/>')
                    .addClass('description')
                    .text('If you have troubles logging into your WebsitePanel account please press F12 key and then set your browser mode to "IE9".')
                )
            );
        }
    });
}(pjQuery));
