<template>
  <div class="blur">
    <div class="wrap">
      <div class="loading">
        <div class="bounceball"></div>
        <div class="text"></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'slackerboard',
};


</script>
<style lang="scss">
$width: 35px;
$height: 35px;

$bounce_height: 100px;

.blur {
  position: fixed;
  width: 100%;
  height: 60vh;
  background: rgba(255, 255, 255, 0.8);
}

.text {
  color: #fbae17;
  display: inline-block;
  margin-left: 5px;
  font-size: 26px;
}

.bounceball {
  position: relative;
  display: inline-block;
  height: 37px;
  width: $width;
    &:before {
      position: absolute;
      content: '';
      display: block;
      top: 0;
      width: $width;
      height: $height;
      border-radius: 50%;
      background-color: #fbae17;
      transform-origin: 50%;
      animation: bounce 500ms alternate infinite ease;
    }
}

@keyframes bounce {
  0% {
    top: $bounce_height;
    height: 5px;
    border-radius: 60px 60px 20px 20px;
    transform: scaleX(2);
  }
  35% {
    height: $height;
    border-radius: 50%;
    transform: scaleX(1);
  }
  100% {
    top: 0;
  }
}


@media only screen and (max-width: 600px) {
  .bounceball::before {
    animation: bounce 220ms alternate infinite ease;
  }

  .blur {
    height: 30vh;
  }
}
</style>
