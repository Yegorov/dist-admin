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