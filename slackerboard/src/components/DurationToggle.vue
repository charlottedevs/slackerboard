<template>
  <form class="form" id="duration-toggle">
    <div class="switch-field">
      <input
        value="/"
        @click="update"
        type="radio"
        id="all"
        name="duration"
        :checked="duration === 'all'"
      />
      <label for="all">This Month</label>
      <input
        value="/latest"
        @click="update"
        type="radio"
        id="week"
        name="duration"
        :checked="duration === 'week'"
      />
      <label for="week">This Week</label>
    </div>
  </form>
</template>

<script>
export default {
  name: 'duration-toggle',
  props: ['duration'],
  methods: {
    update(event) {
      this.$router.push(event.target.value);
    },
  },
};

</script>

<style lang="scss">
.switch-field {
  font-family: "Lucida Grande", Tahoma, Verdana, sans-serif;
  overflow: hidden;
}

.switch-title {
  margin-bottom: 6px;
}

.switch-field input {
  position: absolute !important;
  clip: rect(0, 0, 0, 0);
  height: 1px;
  width: 1px;
  border: 0;
  overflow: hidden;
}

.switch-field label {
  float: left;
}

.switch-field label {
  display: inline-block;
  background-color: #e4e4e4;
  color: rgba(0, 0, 0, 0.6);
  font-size: 14px;
  font-weight: normal;
  text-align: center;
  text-shadow: none;
  padding: 6px 14px;
  border: 1px solid rgba(0, 0, 0, 0.2);
  -webkit-box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3), 0 1px rgba(255, 255, 255, 0.1);
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3), 0 1px rgba(255, 255, 255, 0.1);
  -webkit-transition: all 0.1s ease-in-out;
  -moz-transition:    all 0.1s ease-in-out;
  -ms-transition:     all 0.1s ease-in-out;
  -o-transition:      all 0.1s ease-in-out;
  transition:         all 0.1s ease-in-out;
}

.switch-field label:hover {
  cursor: pointer;
}

.switch-field input:checked + label {
  background-color: #573D7A;
  font-weight: bold;
  color: #fff;
  -webkit-box-shadow: none;
  box-shadow: none;
}

.switch-field label:first-of-type {
  border-radius: 4px 0 0 4px;
}

.switch-field label:last-of-type {
  border-radius: 0 4px 4px 0;
}


@media only screen and (max-width: 560px) {
  .switch-field label {
    font-size: 10px;
    padding: 4px 14px;
  }
}
</style>
