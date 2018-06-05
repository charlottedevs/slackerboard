<template>
  <div id="slackerboard">
    <div class="titlebar">
      <div class="duration-container">
        <duration-toggle
          v-bind:duration="duration"
          ></duration-toggle>
      </div>
      <div class="title-container">
        <h1>Slackerboard</h1>
        <pre>the most active people in our <a href="https://slack.charlottedevs.com" target="_blank">slack community</a><br />(...they should probably get back to work)</pre>
      </div>
    </div>

    <transition name="fade">
    <div v-if="!loading && slackerboardIsPresent">
        <table class="table table-striped">
          <thead>
            <tr>
              <th scope="col"></th>
              <th scope="col">user</th>
              <th
                scope="col"
                class="d-none d-lg-table-cell"
                style="min-width: 400px; text-align: center;"
              >
                most frequently used emoji
              </th>
              <th
                scope="col"
                class="d-none d-md-table-cell"
                style="min-width: 350px; text-align: center;"
              >
                messages per channel
              </th>

              <th
                id="total-messages-col"
                scope="col"
                style="text-align: center;"
              >
                total messages <font-awesome-icon :icon="icon" />
              </th>
            </tr>
          </thead>
          <tbody>
            <slacker
              v-for="(slacker, i) in slackerboard"
              :user="slacker"
              :index="i"
              :reactions="slacker.reactions"
              :messages="slacker.messages"
              :key="slacker.slack_identifier"
            >
            </slacker>
          </tbody>
      </table>
    </div>
  </transition>

  <div class="wrap">
    <div class="emoticon" v-if="!loading && !slackerboardIsPresent">
      ¯\_(ツ)_/¯
    </div>
  </div>

  <div v-if="loading">
    <loading></loading>
  </div>
  </div>
</template>

<script>
/* eslint-disable no-console */
import FontAwesomeIcon from '@fortawesome/vue-fontawesome';
import { faCaretDown } from '@fortawesome/fontawesome-free-solid';
import io from 'socket.io-client';

const wsEndpoint = 'https://api.charlottedevs.com:4200';
const socket = io(wsEndpoint);

const allChannel = 'this_week_slackerboard_updates';
const weeklyChannel = 'all_time_slackerboard_updates';

export default {
  name: 'slackerboard',
  props: ['duration'],
  data() {
    return {
      loading: true,
      week: JSON.parse(localStorage.getItem('week')),
      all: JSON.parse(localStorage.getItem('all')),
    };
  },
  computed: {
    icon() {
      return faCaretDown;
    },
    slackerboard() {
      return this[this.duration];
    },
    slackerboardIsPresent() {
      return this.slackerboard && this.slackerboard.length > 0;
    },
    channel() {
      return this.duration === 'week' ?
        weeklyChannel :
        allChannel;
    },
  },
  /* eslint-disable */
  methods: {
    stopLoading(duration = 1250) {
      if (this.loading === true) {
        setTimeout(function () {
          this.loading = false;
        }.bind(this), duration);
      }
    },
  },
  watch: {
    duration() {
      if (this.loading === true) { return; }

      // put loading icon to hide inappropriate transitions
      // if loading duration is < 500 loading ball will not appear
      this.loading = true;
      this.stopLoading(200)

      if (!this[this.duration]) {
        socket.emit('join', { channel: this.channel });
      }
    },
  },

  /* eslint-disable */
  mounted() {
    socket.on('connect', function() {
      console.log('socket connected cracka');
      socket.emit('join', { channel: weeklyChannel });
      socket.emit('join', { channel: allChannel });
    }.bind(this));

    socket.on('all_time_slackerboard_update', function (data) {
      this.slackerboardHandler(data, 'all');
    }.bind(this));


    socket.on('this_week_slackerboard_update', function (data) {
      this.slackerboardHandler(data, 'week');
    }.bind(this));
  },
  components: {
    FontAwesomeIcon,
  },
};
</script>

<style lang="scss">
@import url('https://fonts.googleapis.com/css?family=Lato');


.reaction > img {
  height: 25px;
  width: 25px;
}

.channel, .reaction {
  display: inline-block;
  margin-right: 5px;
}

.channel > a {
  margin-right: 2px;
}

.handle > a {
  color: inherit;
  font-weight: bold;
}


.table > tbody > tr > td {
  vertical-align: middle;
}

.table > tbody > tr > th {
  vertical-align: middle;
}

img.emoji {
  height: 1.25em;
  width: 1.25em;
  margin: 0 .05em .25em .1em;
}

.reaction {
  font-size: 11px;
  line-height: 16px;
  padding: 2px 3px;
  display: inline-flex;
  align-items: center;
  vertical-align: top;
  background: #fff;
  border: 1px solid #e8e8e8;
  border-radius: 5px;
  margin-right: 4px;
  margin-bottom: 4px;
}

.reaction-count {
  color: #717274;
  padding: 0 1px 0 3px;
}

.handle {
  font-size: .9rem;
}

.titlebar {
  padding: 10px 0px 0px 20px;
  position: relative;
}

.duration-container {
  position: absolute;
  bottom: 0px;
  right: 8px;
}

#total-messages-col {
  min-width: 175px;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}

.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}

.slack-update-enter-active, .slack-update-leave-active {
  transition: all 3s;
  background: yellow !important;
}

.slack-update-enter, .slack-update-leave-to /* .slack-update-leave-active below version 2.1.8 */ {
  opacity: 0;
  transform: translateY(30px);
}

.slack-update-move {
  transition: 1s;
}

@media only screen and (max-width: 560px) {
  .titlebar {
    min-height: 150px;
  }

  .duration-container {
    right: 4vw;
  }

  #total-messages-col {
    min-width: auto;
  }

}
</style>
