<template>
  <v-form>
    <v-container>
      <v-layout row wrap>

        <v-flex xs12 sm6>
          <v-text-field
            v-model="title"
            label="Title"
            color="teal"
            outline
          ></v-text-field>
        </v-flex>

        <!--<v-flex xs12 sm6>-->
          <!--<v-text-field-->
            <!--v-model="last"-->
            <!--label="Last Name"-->
            <!--color="teal"-->
            <!--outline-->
          <!--&gt;</v-text-field>-->
        <!--</v-flex>-->

        <v-flex xs12>
          <v-textarea
            v-model="content"
            color="teal"
            outline
          >
            <div slot="label">
              Content <small>(optional)</small>
            </div>
          </v-textarea>
        </v-flex>

        <v-btn outline color="black">Submit</v-btn>

      </v-layout>
    </v-container>
  </v-form>
</template>

<script>
  export default {
    data: () => ({
      title: 'John',
      content: 'Doe'
    })
  }
</script>
