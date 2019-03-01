/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from "vue/dist/vue.esm"
import App from "../app.vue"
import List from "../components/list.vue"
import Index from "../components/index.vue"

window.store = {}

document.addEventListener("DOMContentLoaded", () => {
  var element = document.querySelector("#list")
  if (element != undefined) {
    window.store.boards = JSON.parse(element.dataset.boards)
    window.store.cards = JSON.parse(element.dataset.cards)
    window.store.lists = JSON.parse(element.dataset.lists)

    const app = new Vue({
      el: element,
      data: window.store,
      template: "<Index :boards='boards' :cards='cards' :lists='lists' />",
      components: { Index }
    })
  }
})
