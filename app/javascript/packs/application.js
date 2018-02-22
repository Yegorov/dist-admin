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
});

Rails.start();
Turbolinks.start();