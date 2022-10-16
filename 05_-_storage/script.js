var ACCESS_TOKEN = '1!nFUyHp5Trn1nodLNcXMw6TT-sACduZQcM6ymUYoO8jZgRjVWncZpX1uQFuZOSqSWXMN2hxCX255BiIftk0BnZPZTC3zYyAkbCikJZ0rmcDcY4UGspDJ7GrlvCbwOCg5HxTvgi6C_XvkEYF31ttgMKXfVsIti1ktUNkxMj_-cjW0ryeeiGzorhhDsDi5N29WRahbaRy6jlNLy8SLB9bxWYutMDjqu2t7GHMGlT63d6g3FT3pK0gWE70bQpCl22pv0eqIZ4CXu_dlHjlltxB06smJrqkesl-QidSqtQ2AQqY9XreFbPRciJEuYcHlHD9DzcEuoAT5r2K4ZMcMxE3etqiY1OQkVBNlSlGy24wnTFfs_FVFjEhFQVuku9tVUm3FNJokaqQC8Zt0aZvXjhWViAEGtbFJA4vjkRFJY6fjp7e6UevGNS6uBSEcGZKoFEgB2H04u_IQZq-m2Ch-BipL7bY4CfHGVuCNQkgQ0I-hMsaYcYRN9nJZpK_1SmcC4NMQVH82YAa9EwG4UuiwAfSNmcQ0Ni5WZk0A3Lqc9s9cvmnxCEqLQstrygitH2djxz8e_4SJ79kYhrZU.';
var FILE_ID_DOC  = '835884711694';
var preview      = new Box.Preview();

// Enable new Excel Online viewer
//preview.enableViewers(['Office']);

preview.addListener('load', function(resp){

    console.log('load');

    console.log(preview.viewer);

    $('.tl-box-fullscreen').click(function(){
        preview.viewer.toggleFullscreen();
    });
    $('.tl-box-next').click(function(){
        preview.viewer.nextPage();
    });
    $('.tl-box-prev').click(function(){
        preview.viewer.previousPage();
    });
    $('.tl-box-zoom-in').click(function(){
        preview.viewer.zoomIn();
    });
    $('.tl-box-zoom-out').click(function(){
        preview.viewer.zoomOut();
    });
    /*$('.tl-box-pages').click(function(){
        $(this).hide();
        $('.tl-box-page-input').show().val($('.tl-box-num').text()).focus().select();
    });
    $('.tl-box-page-input').on('blur', function(){
        $(this).hide();
        $('.tl-box-pages').show();
        preview.viewer.setPage(parseInt($(this).val()));
        preview.viewer.updateCurrentPage(parseInt($(this).val()));
    });
    $(".tl-box-page-input").keyup(function (e) {
        if (e.keyCode == 13) {
            $(this).blur();
        }
    });*/
});
/*preview.addListener('viewer', function(resp){
    console.log('viewer');
});*/
preview.show(
    FILE_ID_DOC,
    ACCESS_TOKEN,
    { container: '.tl-box-viewer'
    , header:              'none'
    , showDownload:          true
    , showAnnotations:      false
    , logoUrl: 'https://d3j0t7vrtr92dk.cloudfront.net/images/transparent.gif'
    }
);

