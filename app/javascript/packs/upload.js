$(document).on('turbolinks:load', function() {

  var f = document.getElementById('upload_file');

  var upload_url = $(f).data('uploadUrl');
  var $progressbar = $('#upload_file_progressbar');

  var $btn = $('#upload_file_button');
  $btn.on('click', onclick);
  function onclick(e) {
    if (f.files.length) {
      $btn.prop('disabled', true);
      processFile();
    }
  }

  function processFile(e) {
    var file = f.files[0];
    var size = file.size;
    var sliceSize = 2 * 1024 * 1024; // 2 megabytes
    var start = 0;

    var progress_current_value = 0;
    var progress_step = sliceSize * 100 / size;
    $progressbar.css('width', progress_current_value+'%')
                .attr('aria-valuenow', progress_current_value);
    $progressbar.addClass('progress-bar-animated');

    setTimeout(loop, 1);

    function loop() {
      var end = start + sliceSize;
      
      if (size - end < 0) {
        end = size;
      }
      
      var s = slice(file, start, end);

      send(s, start, end, sliceSize, size);

      progress_current_value += progress_step;
      $progressbar.css('width', progress_current_value+'%')
                  .attr('aria-valuenow', progress_current_value);

      if (end == size) {
        $progressbar.removeClass('progress-bar-animated');
        $btn.text('File upload successful!');
      }
    }

    function send(piece, start_, end, sliceSize, size) {
      var formdata = new FormData();
      var xhr = new XMLHttpRequest();

      xhr.open('POST', upload_url, true);

      formdata.append('start', start_);
      formdata.append('end', end);
      formdata.append('slice_size', sliceSize);
      formdata.append('size', size);
      formdata.append('file', piece);
      formdata.append('to', $('#to').prop('value'));
      formdata.append('file_name', f.files[0].name);
      formdata.append('unique_id', $('#unique_id').prop('value'));

      formdata.append('authenticity_token', $('meta[name="csrf-token"').prop('content'));

      xhr.send(formdata);

      xhr.onreadystatechange = function() {
        if (this.readyState != 4) return;
        if (this.status != 200) {
          $("#progressbar_wrapper").append('Error upload file!');
          $progressbar.css('width', 0+'%')
                      .attr('aria-valuenow', 0);
          $progressbar.removeClass('progress-bar-animated');
          return;
        }

        if (end < size) {
          start += sliceSize;
          setTimeout(loop, 1);
        }
      }
    }

    /**
     * Formalize file.slice
     */

    function slice(file, start, end) {
      var slice = file.mozSlice ? file.mozSlice :
                  file.webkitSlice ? file.webkitSlice :
                  file.slice ? file.slice : noop;
      
      return slice.bind(file)(start, end);
    }

    function noop() {
    }
  }
});
