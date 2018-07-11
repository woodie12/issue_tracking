<template>
  <v-app>

    <v-toolbar
      color="grey"
      dark
      tabs
      lights-out
    >
      <v-toolbar-title>Issues tracking</v-toolbar-title>

      <v-tabs
        slot="extension"
        v-model="currentItem"
        color="transparent"
        fixed-tabs
        slider-color="yellow"
      >
        <v-tab
          v-for="item in items"
          :href="'#tab-' + item"
          :key="item"
        >
          {{ item }}
        </v-tab>
      </v-tabs>
    </v-toolbar>

    <v-content>
      <router-view/>
    </v-content>




    <v-footer fixed app>
      <span>&copy; 2018</span>
    </v-footer>
  </v-app>
</template>

<script>
export default {
  name: 'App',
  data: () => ({
    // fixed: true,
    currentItem: 'tab-Web',
    items: [
      'Issues', 'Add'
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
