/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

import "./application.css";
import 'bootstrap/dist/css/bootstrap'
import 'selectize/dist/css/selectize'

import * as $ from 'jquery'
import 'selectize'
//import 'popper'
import 'bootstrap'

import ace from 'brace'
import 'brace/mode/python'
import 'brace/mode/ruby'
import 'brace/mode/golang'
import 'brace/mode/javascript'
import 'brace/theme/monokai'


$(document).on('turbolinks:load', function() {
  $('#input-tags').selectize({
      delimiter: ',',
      persist: false,
      create: function(input) {
          return {
              value: input,
              text: input
          }
      }
  });

  initAce();

  var editor = ace.edit("editor");
  editor.setTheme("ace/theme/monokai");
  editor.session.setMode("ace/mode/python");
  //editor.session.setMode('ace/mode/ruby')
  editor.session.setTabSize(4);
  //editor.session.setUseSoftTabs(false);
  //editor.session.setOptions({ tabSize: 2, useSoftTabs: true });

});

Rails.start();
Turbolinks.start();

function initAce() {
  // var mapper = $('#mapper-code');
  // if (mapper != null) {
  //   var language = mapper.data('language');
  //   console.log(language);
  //   var editor = ace.edit('mapper-code');
  //   console.log(editor);
  //   editor.setTheme("ace/theme/monokai");
  //   editor.session.setMode("ace/mode/" + language);
  //   editor.session.setTabSize(4);
  //   editor.session.setUseSoftTabs(false);
  //   editor.setReadOnly(true);
  // }

  initEditor('mapper-code');
  initEditor('reducer-code');

   $(function () {
        $('textarea.ace').each(function () {
            var textarea = $(this);
            var language = textarea.data('language');
            var editDiv = $('<div>', {
                //position: 'absolute',
                //width: textarea.width(),
                //height: textarea.height(),
                //'class': textarea.attr('class')
            }).insertBefore(textarea);
            textarea.css('visibility', 'hidden');
            textarea.css('display', 'none');
            var editor = ace.edit(editDiv[0]);
            //editor.renderer.setShowGutter(false);
            editor.getSession().setValue(textarea.val());
            editor.getSession().setMode("ace/mode/" + language);
            editor.setTheme("ace/theme/monokai");
            // editor.setTheme("ace/theme/idle_fingers");
            editor.session.setTabSize(language == "ruby" ? 2 : 4);
            editor.session.setUseSoftTabs(true);
            editor.setReadOnly(false);
            
            // copy back to textarea on form submit...
            textarea.closest('form').submit(function () {
                textarea.val(editor.getSession().getValue());
            })
        });
    });

}

function initEditor(id_elem) {
  var el = $('#' + id_elem);
  if (el.length) {
    var language = el.data('language');
    var readonly = el.data('readonly') || false;
    var editor = ace.edit(id_elem);

    editor.setTheme("ace/theme/monokai");
    editor.session.setMode("ace/mode/" + language);
    editor.session.setTabSize(language == "ruby" ? 2 : 4);
    editor.session.setUseSoftTabs(true);
    editor.setReadOnly(readonly);
  }
}