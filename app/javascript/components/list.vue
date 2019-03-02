<template>

  <div :data-list="list.table.id" class='col-md-3 align-top card card-body fix' style="box-shadow: none;background-color: rgba(0,0,0,0);min-height: 1000px; min-width: 500px">
    <div class="inline row" style="margin-top: -1%;background: #f3f3f3;padding: 3%;border-radius: 5px;">
      <strong> <p style="text-align: center;margin-top:-100%color:grey;font-size:22px;font-weight: bold;">{{list.table.name}}</p></strong>
    </div>  
    <hr />

    <draggable  :options="{group: 'cards'}" class='dragArea' @end="cardMoved" style="margin-left: 20px !important;max-height: 65%;">
      <card @print-card-name="printCardName" v-for="(card, index) in card_list" v-if="card.table.idList == list.table.id" :card="card" :list="list.table.id" > </card>   
    </draggable>

    <div class="element1">
      <i class="fa fa-plus" v-if="!editing" @click="startEditing"></i>
    </div>
    <div v-if="editing" class="card card-body card-dark" style="margin-top: 10%;max-height: 200px;">
      <textarea v-model="message" ref="message" class="form-control" style="line-height: 81px;"></textarea>
      <span>
        <button @click="submitMessages" class="btn btn-primary" :data-index="list.table.id">Add Card</button>
        <a @click="editing=false">Cancel</a>
      </span>  
    </div>
  </div>



</template>

<script>
import draggable from "vuedraggable";
import card from "components/card";

export default {
  components: { draggable, card },
  name: "lists",
  props: ["list", "cards"],
  data: function() {
    return {
      card_list: this.cards,
      editing: false,
      message: ""
    };
  },
  methods: {
    printCardName(name) {
      console.log(name);
    },
    submitMessages: function(event) {
      // console.log(this.client)
      var data = new FormData();
      // console.log(window.store.client)
      console.log(event.target.dataset.index);
      this.listing_id = event.target.dataset.index;

      data.append("card[id]", this.listing_id);
      data.append("card[idnboard]", this.message);

      Rails.ajax({
        url: "/post_new_card",
        type: "POST",
        data: data,
        dataType: "json",
        success: data => {
          // const index = window.store.lists.findIndex((item) => item.id == this.listing_id);
          console.log(data);
          window.store.cards.push({
            table: { name: this.message, idList: this.listing_id }
          });
          this.message = "";
          this.editing = false;
          // window.store.cards.push();
          // var cardIndex = window.store.cards.length - 1;
          // window.store.cards[cardIndex].table.idList = this.listing_id;
          // window.store.cards[cardIndex].table.name = this.message;
          // this.message = "";
        }
      });
    },

    deleteList: function() {
      Rails.ajax({
        url: "/listings/" + this.list.id,
        type: "Delete",
        dataType: "json",
        success: () => {
          var list_index = window.store.lists.findIndex(
            item => item.id == this.list.id
          );
          window.store.lists.splice(list_index, 1);
        }
      });
    },

    cardMoved: function(event) {
      console.log(event.to.parentNode.dataset.list);
      console.log(event.item.dataset.id);
      // var new_column = event.to.offsetParent.dataset.index;
      var card_id = event.item.dataset.id;
      var list_id = event.to.parentNode.dataset.list;

      var data = new FormData();
      data.append("card[card_id]", card_id);
      data.append("card[list_id]", list_id);

      Rails.ajax({
        url: "/move_card",
        type: "PATCH",
        data: data,
        dataType: "json"
      });
    },

    startEditing: function() {
      (this.editing = true),
        this.$nextTick(() => {
          this.$refs.message.focus();
        });
    }
  }
};
</script>

<style scoped>
</style>

// trello_secret: f2396a3788ebadc88855e8d22a28a6e42db09b67defcbf5e50effef4c619d400
// trello_token: 4d22e16cb530b809520d3ee38d72590c5a67c1e8aff43b279e7af9f29508b0e9
// trello_key: cd3c6a6e25d03dd94768c6f6eea13a47


// curl -X POST -H “Content-Type: application/json” \
// https://api.trello.com/1/tokens/4d22e16cb530b809520d3ee38d72590c5a67c1e8aff43b279e7af9f29508b0e9/webhooks/ \
// -d ‘{
//   “key”: “cd3c6a6e25d03dd94768c6f6eea13a47”,
//   “callbackURL”: “http://4f4ba129.ngrok.io”,
//   “idModel”:”4d5ea62fd76aa1136000000c”,
//   “description”: “My first webhook”  
// }’

//  curl -X POST -H "Content-Type: application/json" \
//  https://api.trello.com/1/tokens/4d22e16cb530b809520d3ee38d72590c5a67c1e8aff43b279e7af9f29508b0e9/webhooks/ \
//  -d '{
//    "key": "cd3c6a6e25d03dd94768c6f6eea13a47",
//    "callbackURL": "https://4f4ba129.ngrok.io",
//    "idModel":"4d5ea62fd76aa1136000000c",
//    "description": "My first webhook"  
//  }'