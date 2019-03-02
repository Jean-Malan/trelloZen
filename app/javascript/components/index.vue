<template>
<div class="container">
  <nav></nav>
    <draggable v-model="lists" :options="{group: 'lists'}" class='row dragArea' style="margin-left:5%">
      <lists v-for="(list, index) in lists" :cards="cards" :list="list"></lists>
    </draggable>
  </div>
</template>


<script>
import draggable from "vuedraggable";
import lists from "./list";

export default {
  components: { draggable, lists },
  props: ["boards", "cards", "lists"],
  data: function() {
    return {
      editing: false,
      message: "",
      newList: false,
      listName: ""
    };
  },

  methods: {}
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

.dragArea {
  min-height: 20px;
  background-color: aliceblue;
}

.row {
  overflow-x: scroll; /* Add vertical scrollbar */
  display: inline-flex !important;
}
.body {
  background-color: #89bdd3 !important;
}
.list {
  vertical-align: top !important;
}

.card .card-body .card-dark {
  background-color: #89bdd3;
}

.col-md-3 {
  background-color: #89bdd3;
  border-style: solid;
  border-color: #89bdd3;
  border-radius: 20px;
  border: 10px;
}
</style>