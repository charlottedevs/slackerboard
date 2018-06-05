<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>

export default {
  name: 'app',
};
</script>

<style type="text/css">

html, body {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
  overflow: auto;
}

#app {
  font-family: 'Lato', Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

pre {
  white-space: pre-wrap;       /* css-3 */
  white-space: -moz-pre-wrap;  /* Mozilla, since 1999 */
  white-space: -pre-wrap;      /* Opera 4-6 */
  white-space: -o-pre-wrap;    /* Opera 7 */
  word-wrap: break-word;       /* Internet Explorer 5.5+ */
}

.emoticon {
  font-size: 42px;
  color: darkgrey;
}

.wrap {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: fit-content;
}

@media only screen and (max-width: 600px) {
  html {
    overflow-y: scroll;
    overflow-x: hidden;
  }

  h1 {
    font-size: 2rem;
  }
  pre {
    font-size: 0.65rem;
  }

  table thead th {
    font-size: .7rem;
  }

  .wrap {
    top: 20%;
  }

  .emoticon {
    font-size: 32px;
  }
}


.updated {
  background:yellow !important;
}

.updateable {
  -webkit-transition:background 1s;
  -moz-transition:background 1s;
  -o-transition:background 1s;
  transition:background 1s
}

</style>
