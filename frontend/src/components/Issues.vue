<template>
  <div>

    <v-card flat>
      <v-container fluid>
        <v-layout row child-flex wrap>

          <div>
            <v-toolbar>
              <v-toolbar-title>Issues</v-toolbar-title>

              <v-spacer></v-spacer>


            </v-toolbar>
          </div>

          <div style="flex-basis: 20%">
            <v-toolbar dark>
              <v-spacer></v-spacer>
              <router-link :to="{ path: '/post' }" >
                <v-btn icon>
                  <v-icon >note_add</v-icon>
                </v-btn>
              </router-link>

            </v-toolbar>
          </div>
        </v-layout>
      </v-container>
    </v-card>

    <br>
    <br>
    <br>

    <v-container fluid>
    <v-flex xs12>
      <v-expansion-panel popout>
        <v-expansion-panel-content
          v-for="item in items"
          :key="item.id"
        >
          <div slot="header">{{item.title}}</div>
          <v-card>
            <v-card-text>
              <v-divider></v-divider>
              <br>
              {{item.content}}
              <br>
            </v-card-text>
            <v-btn icon>
              <v-icon >thumb_up</v-icon>
            </v-btn>
            <v-btn icon>
              <v-icon >thumb_down</v-icon>
            </v-btn>
            <v-btn icon v-on:click="handle_delete(item.id)">
              <v-icon >delete</v-icon>
            </v-btn>
          </v-card>
        </v-expansion-panel-content>
      </v-expansion-panel>
    </v-flex>
    </v-container>

  </div>
</template>

<script>
  export default {
    name: "Issue",
    data: () => ({
      items: []
    }),
    mounted () {
      this.axios
        .get('/issues/list')
        .then((response) => {
          console.log("data is ", response.data)
          this.items = response.data
        })
      console.log(this.items)
    },
    methods: {
      handle_delete: function (id) {
        console.log(id)
        this.axios
          .get('/issues_delete/'+id)
          .then((response) => {
            console.log("data is ", response.data,'/issues_delete/'+id)
            this.axios
              .get('/issues/list')
              .then((response) => {
                console.log("data is ", response.data)
                this.items = response.data
              })
          })
        }
    }


  }
</script>

<style scoped>

</style>
