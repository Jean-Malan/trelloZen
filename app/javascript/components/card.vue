<template>
 <div class="card card-body" :data-id="card.table.id" :parentId="card.table.idList" style="margin-top:10px;margin-top: 10px;min-height: 120px;border-left-style: solid;border-left-width: 10px;">
  <div class="to-do-card-label">
    <p style="position:overlay; margin-left: 50%;padding-top: 0%; font-size: 1em;width: 1000%;"><strong>Card Name: </strong> {{card.table.name}}<br></p>
  </div>
</div>

</template>

  <script>
export default {
  props: ["card"],
  data: function() {
    return {
      showList: false,
      color: "#194d33",
      cardId: "",
      parentId: "",
      showTagBody: true,
      showTimeSheet: false,
      editing: false,
      listingId: "",
      cardListing: this.card_list
    };
  },
  methods: {
    printCardName(name) {
      this.$emit("print-card-name", name);
    },
    addTag: function(event) {
      var card_id = this.id;
      var listing_id = this.parentId;
      var tag_id = event.target.attributes[1].value;
      // var list_id = window.store.lists.findIndex((item) => item.id = listing_id)
      var card = card_list.findIndex(item => item.id == card_id);
      var data = new FormData();
      data.append("card[tag_id]", tag_id);

      Rails.ajax({
        url: "/card/" + this.id,
        type: "PATCH",
        data: data,
        dataType: "json",
        success: data => {
          this.card_list[card].tag_id = tag_id;
        }
      });
    }
  },
  watch: {}
};
</script>

  <style>
html {
  background-color: blue;
}
table {
  margin: 0, 0, 0, 0;
  padding: 0, 0, 0, 0;
}
.slideout-menu {
  position: fixed;
  top: 0;
  bottom: 0;
  width: 256px;
  height: 100vh;
  overflow-y: scroll;
  -webkit-overflow-scrolling: touch;
  z-index: 0;
  display: none;
  background-color: #1d1f20;
  color: white;
}

.slideout-menu-left {
  left: 0;
}

.slideout-menu-right {
  right: 0;
}

.slideout-panel {
  background-color: #4b5;
  color: white;
  position: relative;
  z-index: 1;
  will-change: transform;
  min-height: 100vh;
}

.slideout-open,
.slideout-open body,
.slideout-open .slideout-panel {
  overflow: hidden;
}

.slideout-open .slideout-menu {
  display: block;
}
</style>