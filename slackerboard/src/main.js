// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';
import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap-vue/dist/bootstrap-vue.css';
import Slacker from '@/components/Slacker';
import SlackChannel from '@/components/SlackChannel';
import SlackReaction from '@/components/SlackReaction';
import DurationToggle from '@/components/DurationToggle';
import Loading from '@/components/Loading';
import emoji from './emoji';
import { slackerboardHandler } from './slackerboard';
import router from './router';
import App from './App';

Vue.component('slacker', Slacker);
Vue.component('slack-channel', SlackChannel);
Vue.component('slack-reaction', SlackReaction);
Vue.component('duration-toggle', DurationToggle);
Vue.component('loading', Loading);

Vue.config.productionTip = false;

Vue.prototype.emoji = emoji;
Vue.prototype.slackerboardHandler = slackerboardHandler;
Vue.use(BootstrapVue);


/* eslint-disable no-new */
export default new Vue({
  el: '#app',
  data: {
    foo: 'bar',
  },
  router,
  components: { App },
  template: '<App/>',
});
