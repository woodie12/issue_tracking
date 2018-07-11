import Vue from 'vue'
import Router from 'vue-router'

import Issues from '@/components/Issues'
import AddIssue from '@/components/AddIssue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Issues',
      component: Issues
    },
    {
      path: '/post',
      name: 'AddIssue',
      component: AddIssue
    }
  ]
})
