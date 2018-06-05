<template>
  <transition name="slack-update">
    <span :class="classObject">
      <a :href="slackChannel(channel.slack_identifier)" target="_blank">#{{channel.channel}}</a>
      <span class="message-count">{{channel.messages_sent}}</span>
    </span>
  </transition>
</template>

<script>
export default {
  name: 'slack-channel',
  data() {
    return {
      classObject: {
        'slack-channel': true,
        updateable: true,
        updated: false,
      },
    };
  },
  props: ['channel'],
  methods: {
    slackChannel(id) {
      return `https://charlottedevs.slack.com/messages/${id}`;
    },
  },

  watch: {
    /* eslint-disable */
    'channel.messages_sent': function() {
      if (this.classObject.updated) { return; }
      this.classObject.updated = true;
      setTimeout(function() {
        this.classObject.updated = false;
      }.bind(this), 1000);
    },
  },

};

</script>

<style lang="scss">

.slack-channel {
  font-size: 14px;
  line-height: 20px;
  padding: 3px 4px;
  display: inline-flex;
  align-items: center;
  vertical-align: top;
  background: #fff;
  border: 1px solid #e8e8e8;
  border-radius: 5px;
  margin-right: 4px;
  margin-bottom: 4px;
}


.slack-channel > a {
  margin-right: 2px;
}

.message-count {
  color: #717274;
  padding: 0 1px 0 3px;
  margin-top: 3px;
  font-size: 11px;
}
</style>
