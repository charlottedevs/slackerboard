<template>
  <tr class="slacker">
    <th scope="row">
      <div style="position: relative;">
        <img id="crown" v-if="index === 0" src="static/images/crown.png" />
        <img v-bind:src="user.profile_image" alt="avatar" height="50" width="50"/>
      </div>
    </th>
    <td class="handle">
      <a :href="dm(user.slack_identifier)" target="_blank">
        @{{user.slack_handle}}
      </a>
    </td>
    <td
      class="d-none d-lg-table-cell"
      style="max-width: 60vw; text-align: center;"
    >
      <slack-reaction
        v-for="reaction in user.reactions"
        v-bind:reaction="reaction.emoji"
          v-bind:reactions_given="reaction.reactions_given"
          v-bind:key="reaction.emoji"
      ></slack-reaction>
    </td>

    <td
      class="d-none d-md-table-cell"
      style="text-align: center;"
    >
      <slack-channel
        v-for="channel in user.messages"
        v-bind:channel="channel"
        v-bind:key="channel.slack_identifier"
      ></slack-channel>
    </td>

    <td style="text-align: center;">
      <div class="message-count">
        {{user.message_count}}
      </div>
    </td>
  </tr>
</template>

<script>
export default {
  name: 'slacker',
  props: ['user', 'index'],
  methods: {
    dm(id) {
      return `https://charlottedevs.slack.com/messages/@${id}`;
    },
  },
};

</script>

<style lang="scss">
.handle > a {
  color: inherit;
  font-weight: bold;

  &:hover {
    text-decoration: inherit;
    color: grey;
  }
}

#crown {
  width: 14px;
  position: absolute;
  left: -8px;
  top: -11px;
  transform: rotate(-20deg);
}

</style>
