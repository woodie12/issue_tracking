<template>
  <v-form>

    <v-container>

      <v-layout row wrap>

        <v-flex xs12 sm6>
          <v-text-field
            v-model="input.title"
            label="Title"
            color="teal"
            outline
          ></v-text-field>
        </v-flex>


        <v-flex xs12>
          <v-textarea
            v-model="input.content"
            color="teal"
            outline
          >
            <div slot="label">
              Content <small>(optional)</small>
            </div>
          </v-textarea>
        </v-flex>

        <v-btn outline color="black"
               v-on:click="handle_submit">Submit</v-btn>

      </v-layout>
    </v-container>
  </v-form>
</template>

<script>
  export default {
    name: "AddIssue",
    data: () => ({
      input: {
        title: '',
        content: ''
      }

    }),
    methods: {
      //axios: CORS request, need to stringify beforehand
      handle_submit: function () {
        // `this` inside methods points to the Vue instance
        console.log(this.input)
        const body = {"title": this.input.title, "content": this.input.content}
        console.log(JSON.stringify(body))
        this.axios.
        post('http://localhost:3000/issues_set/add',
          JSON.stringify(body))
          .then(response => {
            console.log(response)
          })
          .catch(e => {
            console.log(e)
          })
      }
    }
  }
</script>
