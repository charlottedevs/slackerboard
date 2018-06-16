import Vue from 'vue';
import Router from 'vue-router';
import Slackerboard from '@/components/Slackerboard';
import NotFound from '@/components/NotFound';

Vue.use(Router);

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'Slackerboard',
      component: Slackerboard,
      props: { duration: 'all' },
    },
    {
      path: '/latest',
      name: 'Slackerboard',
      component: Slackerboard,
      props: { duration: 'week' },
    },
    {
      path: '*',
      component: NotFound,
    },
  ],
});
