<template>
  <transition name="slack-update">
    <span :class="classObject">
      <span v-html="convert(reaction)"></span>
      <span class="reaction-count">{{reactions_given}}</span>
    </span>
  </transition>
</template>

<script>
export default {
  name: 'slack-reaction',
  data() {
    return {
      classObject: {
        'slack-reaction': true,
        updateable: true,
        updated: false,
      },
    };
  },
  props: ['reaction', 'reactions_given'],
  methods: {
    dm(id) {
      return `https://charlottedevs.slack.com/messages/@${id}`;
    },
    convert(name) {
      return this.emoji.slackEmoji(name);
    },
  },

  watch: {
    /* eslint-disable */
    reactions_given: function() {
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
.slack-reaction > img {
  height: 25px;
  width: 25px;
}

.slack-reaction {
  display: inline-block;
  margin-right: 5px;
}

.handle > a {
  color: inherit;
  font-weight: bold;
}

img.emoji {
  height: 1.25em;
  width: 1.25em;
  margin: 0 .05em .25em .1em;
}

.slack-reaction {
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
</style>
