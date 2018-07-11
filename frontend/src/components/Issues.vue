<template>
  <div>
    <!--TODO: move toolbar to App.vue-->
    <!--<v-toolbar-->
      <!--color="grey"-->
      <!--dark-->
      <!--tabs-->
      <!--lights-out-->
    <!--&gt;-->
      <!--<v-toolbar-title>Issues tracking</v-toolbar-title>-->
      <!--<v-spacer></v-spacer>-->
      <!--<v-btn icon>-->
        <!--<v-icon>more_vert</v-icon>-->
      <!--</v-btn>-->

      <!--<v-tabs-->
        <!--slot="extension"-->
        <!--v-model="currentItem"-->
        <!--color="transparent"-->
        <!--fixed-tabs-->
        <!--slider-color="yellow"-->
      <!--&gt;-->
        <!--<v-tab-->
          <!--v-for="item in items"-->
          <!--:href="'#tab-' + item"-->
          <!--:key="item"-->
        <!--&gt;-->
          <!--{{ item }}-->
        <!--</v-tab>-->

        <!--<v-menu-->
          <!--v-if="more.length"-->
          <!--bottom-->
          <!--class="v-tabs__div"-->
          <!--left-->
        <!--&gt;-->

          <!--TODO: change this to all issues listed -->
          <!--<v-list class="grey lighten-3">-->
            <!--<v-list-tile-->
              <!--v-for="item in more"-->
              <!--:key="item"-->
              <!--@click="addItem(item)"-->
            <!--&gt;-->
              <!--{{ item }}-->
            <!--</v-list-tile>-->
          <!--</v-list>-->
          <!--TODO: Add to list, list for the map -->

        <!--</v-menu>-->
      <!--</v-tabs>-->


    <!--</v-toolbar>-->


    <v-tabs-items v-model="currentItem">
      <v-tab-item
        v-for="item in items.concat(more)"
        :id="'tab-' + item"
        :key="item"
      >
        <v-card flat>
          <v-card-text>
            <h2>{{ item }}</h2>
            {{ text }}
          </v-card-text>
        </v-card>
      </v-tab-item>
    </v-tabs-items>



    <v-flex xs10 justify-center>
      <v-expansion-panel>
        <v-expansion-panel-content
          v-for="(item,i) in 5"
          :key="i"
        >
          <div slot="header">Item</div>
          <v-card>
            <v-card-text>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</v-card-text>
          </v-card>
        </v-expansion-panel-content>
      </v-expansion-panel>
    </v-flex>

  </div>
</template>

<script>
  export default {
    name: "add-issue",
    data: () => ({
      currentItem: 'tab-Web',
      items: [
        'Issues', 'Add'
      ],
      more: [
        'News', 'Maps', 'Books', 'Flights', 'Apps'
      ],
      text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
    }),
    methods: {
      addItem (item) {
        const removed = this.items.splice(0, 1)
        this.items.push(
          ...this.more.splice(this.more.indexOf(item), 1)
        )
        this.more.push(...removed)
        this.$nextTick(() => { this.currentItem = 'tab-' + item })
      }
    }
  }
</script>

<style scoped>

</style>
