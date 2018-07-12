<template>
  <v-app>
    <div>
      <v-card
        color="grey lighten-4"
        flat
        height="100px"
        tile
      >
        <v-toolbar dense>
          <v-icon>info</v-icon>
          <v-toolbar-title >Issue tracking</v-toolbar-title>
        </v-toolbar>
      </v-card>
    </div>

            <v-content>
              <router-view/>
            </v-content>

          <!--</v-tab-item>-->
        <!--</v-tabs-items>-->

      <!--</v-tabs>-->
    <!--</v-toolbar>-->




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
      {
        name: 'Issues',
        url: '/'
      },
      {
        name: 'New Issue',
        url:'/post'
      }
    ]
  })
}
</script>
